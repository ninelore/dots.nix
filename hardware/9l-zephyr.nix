# Partially formerly /etc/nixos/hardware-configuration.nix from 9l-zephyr
{ config, lib, inputs, pkgs, modulesPath, ... }: {
  imports = [
    inputs.nixos-hardware.nixosModules.asus-zephyrus-ga402
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  networking.hostName = "9l-zephyr";

  # Autologin since its pointless on FDE
  services.displayManager.autoLogin = {
    enable = true;
  };

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
    supergfxd.enable = true;
  };

  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
  ];

  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "sdhci_pci" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/65e11003-44dc-4d04-bddd-3d0abe63188f";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/9c50dbd6-3a0b-4b6b-86b0-f326320a27dd";

  fileSystems."/.snapshots" =
    {
      device = "/dev/disk/by-uuid/65e11003-44dc-4d04-bddd-3d0abe63188f";
      fsType = "btrfs";
      options = [ "subvol=@.snapshots" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-uuid/65e11003-44dc-4d04-bddd-3d0abe63188f";
      fsType = "btrfs";
      options = [ "subvol=@nix" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/65e11003-44dc-4d04-bddd-3d0abe63188f";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/8C76-9B64";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  # networking.interfaces.br-040f884d64c7.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-5785f70ee441.useDHCP = lib.mkDefault true;
  # networking.interfaces.docker0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlan0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
