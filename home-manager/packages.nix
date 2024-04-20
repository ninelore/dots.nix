{pkgs, ...}: {
  imports = [
    ./scripts/nx-switch.nix
  ];

  home.packages = with pkgs; with gnome; [
    # cli
    btop
    gnutar
    fastfetch
    htop
    less
    neofetch
    nixpkgs-fmt
    oh-my-posh
    ranger
    unar
    ueberzug
    w3m
    zip
    unzip

    # gui
    obsidian
    vscode-fhs
    libreoffice
    gimp
    webcord
    thunderbird
    microsoft-edge
    protonmail-bridge
    protonmail-bridge-gui
    
    # dev
    nodejs_20
    python3
    yarn
    go
    rustup

    # gaming
    lutris
    steam
    wineWowPackages.stagingFull
  ];
}
