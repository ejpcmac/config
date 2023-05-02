################################################################################
##                                                                            ##
##              Home configuration for jpc with the ZFS feature               ##
##                                                                            ##
################################################################################

{
  ############################################################################
  ##                                Aliases                                 ##
  ############################################################################

  confkit.programs.zsh.plugins = [ "zfs" ];

  programs.zsh = {
    shellAliases = {
      zly = "zfs list -o name,jpc:manager,readonly,compression,compressratio,used,usedbysnapshots,com.sun:auto-snapshot,encryptionroot";
      wzly = "watch -n 1 zfs list -o name,jpc:manager,readonly,compression,compressratio,used,usedbysnapshots,com.sun:auto-snapshot,encryptionroot";
    };

    initExtra = ''
      szihk() {
          if [ $# -ne 1 ]; then
              echo "usage: zihk <dataset>"
              exit 1
          fi

          local passphrase

          sudo -v
          echo -n "Enter passphrase: "
          read -s passphrase
          echo

          for dataset in $(zfs list -rHo name $1); do
              echo "$passphrase" | sudo zfs load-key $dataset
              sudo zfs change-key -i $dataset
          done
      }
    '';
  };
}
