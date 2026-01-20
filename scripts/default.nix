{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/scripts";
in
{
  home.file.".local/bin/screenshot.sh" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/screenshot.sh";
  };

  home.file.".local/bin/proxy.sh" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/proxy.sh";
  };

  home.sessionPath = [ "$HOME/.local/bin" ];
}
