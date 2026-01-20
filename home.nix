{
  config,
  pkgs,
  nixpkgs-unstable,
  MyNixvim,
  ...
}:
let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  unstable = import nixpkgs-unstable {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };

  configs = {
    picom = "picom";
    dunst = "dunst";
  };
in
{
  imports = [
    ./modules/suckless.nix
    ./scripts/default.nix
  ];

  home.username = "mayon";
  home.homeDirectory = "/home/mayon";
  home.stateVersion = "25.11";

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" ];
    };
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos-btw";
    };
    history.size = 10000;
    zplug = {
      enable = true;
      plugins = [
        { name = "Aloxaf/fzf-tab"; }
      ];
    };
  };

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      qt6Packages.fcitx5-chinese-addons
      fcitx5-nord
      catppuccin-fcitx5
    ];
  };

  home.file.".dwm/autostart.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      slstatus &
      feh --bg-scale ${dotfiles}/wallpaper/wallpaper.jpg &
      picom -b &
      dunst &
      fcitx5 &
      greenclip daemon &
    '';
  };

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
    x11.defaultCursor = "Bibata-Modern-Ice";
    gtk.enable = true;
    x11.enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "MayonLos";
        email = "ml20061023@outlook.com";
      };
      init.defaultBranch = "main";
    };
  };

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "thunar.desktop" ];
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  home.packages = with pkgs; [
    fzf
    nodejs
    gcc
    xclip
    feh
    picom
    dunst
    libnotify
    pamixer
    brightnessctl
    fastfetch
    unzip
    bibata-cursors
    maim
    python315
    gnumake
    ranger
    prismlauncher
    flclash
    tmux
    MyNixvim.packages.${pkgs.stdenv.hostPlatform.system}.default

    unstable.qq
    unstable.go-musicfox
    unstable.vscode
  ];
}
