{ config, lib, pkgs, ... }:

let
  inherit (lib) concatMapStrings concatStringsSep literalExample mapAttrsToList
    mkOption optionalString;
  inherit (lib.types) attrsOf bool listOf str submodule;

  cfg = config.services.influxdb;

  # Require cfg.adminUser to be set when authentication is enabled. Using dumb
  # values otherwise.
  adminUsername = if cfg.enableAuth then cfg.adminUser.name else "admin";
  adminPassword = if cfg.enableAuth then cfg.adminUser.password else "admin";

  adminUser = submodule {
    options = {
      name = mkOption {
        type = str;
        description = "The username for the default admin user.";
        example = "admin";
      };

      password = mkOption {
        type = str;
        description = "The password for the default admin user.";
        example = "admin";
      };
    };
  };

  user = submodule {
    options = {
      name = mkOption {
        type = str;
        description = "The name of the user to ensure.";
        example = "telegraf";
      };

      password = mkOption {
        type = str;
        description = "The password of the user to ensure.";
        example = "influxdb4telegraf";
      };

      isAdmin = mkOption {
        type = bool;
        default = false;
        description = "Wether the user should be created as an admin.";
        example = true;
      };

      ensurePermissions = mkOption {
        type = attrsOf str;
        default = { };
        description = ''
          Permissions to ensure for the user, specified as an attribute set. The
          attribute name specify the database to grant the permissions for. The
          attribute value specify the permission to grant.
        '';
        example = literalExample "{ telegraf = \"WRITE\"; }";
      };
    };
  };
in

{
  options.services.influxdb = {
    enableAuth = mkOption {
      type = bool;
      default = false;
      description = "Wether to enable authentication.";
      example = true;
    };

    adminUser = mkOption {
      type = adminUser;
      description = "The default admin user.";
      example = literalExample "{ name = \"admin\"; password = \"admin\" }";
    };

    ensureUsers = mkOption {
      type = listOf user;
      default = [ ];
      description = ''
        Ensures that the specified users exist and have at least the ensured
        permissions when the service starts.

        This option will never delete or change the password of existing users,
        especially not when the value of this option is changed.
      '';
      example = literalExample ''
        [
          {
            name = "telegraf";
            password = "influxdb4telegraf";
            ensurePermissions = { telegraf = "WRITE"; };
          }

          {
            name = "grafana";
            password = "influxdb4grafana";
            ensurePermissions = { telegraf = "READ"; };
          }

          {
            name = "otherAdmin";
            password = "otherAdmin";
            isAdmin = true;
          }
        ]
      '';
    };

    ensureDatabases = mkOption {
      type = listOf str;
      default = [ ];
      description = ''
        Ensures that the specified databases exist when the service starts.

        This option will never delete existing databases, especially not when
        the value of this option is changed. This means that databases created
        through this option or otherwise have to be removed manually.
      '';
      example = [ "telegraf" ];
    };
  };

  config = {
    services.influxdb = {
      extraConfig.http.auth-enabled = cfg.enableAuth;
    };

    systemd.services.influxdb = {
      postStart = ''
        INFLUX="${pkgs.influxdb}/bin/influx -username ${adminUsername} -password ${adminPassword}"

        ${optionalString cfg.enableAuth ''
          $INFLUX -execute "CREATE USER ${adminUsername} WITH PASSWORD '${adminPassword}' WITH ALL PRIVILEGES"
        ''}

        ${concatMapStrings (database: ''
          $INFLUX -execute "SHOW DATABASES" | grep -q '^${database}$' \
            || $INFLUX -execute "CREATE DATABASE ${database}"
        '') cfg.ensureDatabases}

        ${concatMapStrings (user: ''
          $INFLUX -execute "SHOW USERS" | grep -q '^${user.name} ' \
            || $INFLUX -execute "CREATE USER ${user.name} WITH PASSWORD '${user.password}'"

          ${optionalString user.isAdmin ''
            $INFLUX -execute "GRANT ALL PRIVILEGES TO ${user.name}"
          ''}

          ${concatStringsSep "\n" (mapAttrsToList (database: permission: ''
            $INFLUX -execute "GRANT ${permission} ON ${database} TO ${user.name}"
          '') user.ensurePermissions)}
        '') cfg.ensureUsers}
      '';
    };
  };
}
