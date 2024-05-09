{ pkgs, ... }:
let
  edge = pkgs.microsoft-edge.override {
    commandLineArgs = [
      "--ozone-platform-hint=auto"
      "--ozone-platform=wayland"
    ];
  };
in
{
  imports = [
    ./scripts/nix-helpers.nix
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };

  home.packages = with pkgs; with gnome; [
    # cli
    btop
    distrobox
    coreboot-utils
    fastfetch
    gnutar
    less
    minicom
    oh-my-posh
    ranger
    unar
    ueberzug
    w3m
    zip
    unzip

    # appimages
    appimage-run

    # gui
    anytype
    obsidian
    libreoffice
    gimp
    webcord
    edge
    protonmail-desktop
    helvum

    # Mail
    #thunderbird
    #protonmail-bridge
    #protonmail-bridge-gui

    # dev
    nixd
    nixfmt-rfc-style
    nixpkgs-fmt
    # TODO: define globally available shell envs
    nodejs_20
    python3
    yarn
    go
    gcc
    rustup

    # gaming
    #lutris # flatpak
    wineWowPackages.stagingFull
  ];
}
