################################################################################
##                                                                            ##
##                              Groups on Helios                              ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

{
  users.groups = {
    data.gid = 2000;
    musique.gid = 2001;
    videos.gid = 2002;
    docs.gid = 2003;
  };
}
