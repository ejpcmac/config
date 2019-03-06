self: super:

{
  ranger = super.ranger.overrideAttrs (old: {
    LANG = "en_US.UTF-8";
  });

  vim_configurable = super.vim_configurable.override {
    guiSupport = "no";
  };
}
