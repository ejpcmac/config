################################################################################
##                                                                            ##
##                         Configuration for servers                          ##
##                                                                            ##
################################################################################

{ config, lib, ... }:

{
  config = lib.mkIf (builtins.elem "server" config.confkit.profile.usage) {

    ########################################################################
    ##                              confkit                               ##
    ########################################################################

    confkit = {
      # Use Vim as a lightweight backup for Emacs TRAMP.
      programs.vim.enable = true;
    };
  };
}
