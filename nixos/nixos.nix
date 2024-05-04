{ pkgs, lib, inputs, ... }: {
  system.stateVersion = "24.05";

  imports = [
    /etc/nixos/hardware-configuration.nix
    ./boot.nix
    ./audio.nix
    ./locale.nix
    ./login.nix
    ./hyprland.nix
  ]
  ++ lib.optional (lib.strings.fileContents "/etc/nixos/HOSTNAME" == "9l-zephyr") ./ga402r.nix
  ++ lib.optional (lib.strings.fileContents "/sys/class/dmi/id/sys_vendor" == "Google") ./cros.nix;

  documentation.nixos.enable = false;
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    substituters = [
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };
    libvirtd.enable = true;
  };

  services.logind.extraConfig = ''
    HandlePowerKey=suspend
    HandleLidSwitch=suspend
    HandleLidSwitchDocked=ignore
  '';

  services = {
    #printing.enable = true;
    flatpak.enable = true;
  };

  networking = {
    networkmanager.enable = true;
    firewall = rec {
      allowedTCPPortRanges = [
        # Example
        #{
        #  from = 1714;
        #  to = 1764;
        #}
      ];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
    openrazer = {
      enable = true;
      batteryNotifier.enable = false;
    };
  };

  environment = {
    localBinInPath = true;
    systemPackages = with pkgs; [
      curl
      git
      gh
      home-manager
      neovim
      nix-index
      inputs.nix-alien.packages.${pkgs.system}.nix-alien
    ];
  };

  programs = {
    virt-manager.enable = true;
    nix-ld.enable = true;
    # I hate to have this outside of home-manager...
    steam = {
      enable = true;
      gamescopeSession.enable = true; # TODO: trial
    };
  };
}
