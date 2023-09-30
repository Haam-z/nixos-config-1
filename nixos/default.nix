{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    ./hardware-config.nix
  ];

  # Flatpack And Nix
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  services.flatpak.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.system = "x86_64-linux";
  nix = {

    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;

    enable = true;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-substituters = [ "http://cache.nixos.org" ];
      substituters = [ "http://cache.nixos.org" ];
      auto-optimise-store = true;
      cores = 0;
      max-jobs = 1;
      sandbox = false;
    };
    #package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    gc.automatic = true;
  };
  nixpkgs = {
    # You can add overlays here
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
  };

  nix = { };
  # User
  users.users.haam = {
    isNormalUser = true;
    home = "/home/haam";
    initialPassword = "221";
    description = "Hamza zarrouk";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };
  # Locale And Time
  time.timeZone = "Africa/Tunis";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
  # Boot loader
  boot.loader.grub = {
    enable = true;
    devices = [ "nodev" ];
    efiSupport = true;
  };
  # kernel
  boot = {
    kernelParams = [ "i915.force_probe=9a49" ];
    kernelPackages = pkgs.linuxPackages_testing;
  };
  # File system

  boot.supportedFilesystems = [ "ntfs" ];
  services = {
    fstrim.enable = true;
    gvfs.enable = true;
  };
  zramSwap = {
    enable = true;
    algorithm = "lz4";
  };
  # GPU
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      intel-media-driver
    ];
  };
  # Sound
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    jack.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
  # Printing
  services = {
    printing = {
      enable = true;
      startWhenNeeded = true;
      drivers = with pkgs; [
        gutenprint
        gutenprintBin
        hplip
        hplipWithPlugin
        postscript-lexmark
        samsung-unified-linux-driver
        splix
        brlaser
        brgenml1lpr
        cnijfilter2
      ];
    };
    avahi = {
      enable = true;
      nssmdns = true;
      # for a WiFi printer
      openFirewall = true;
    };
  };
  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
    powerOnBoot = true;
  };
  # Fonts
  fonts = {
    enableDefaultFonts = true;
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = [ pkgs.haam-fonts pkgs.nerdfonts ];
  };
  # Networking
  networking = {
    networkmanager.enable = true;
    nameservers = [ "1.1.1.3" "1.0.0.3" ];
    networkmanager.dns = "none";
  };
  # Virtualisation
  virtualisation = {
    docker = { enable = true; };
    libvirtd = { enable = true; };
  };
  # Display Manager
  services.xserver.displayManager = {
    gdm.wayland = true;
    gdm.enable = true;
  };
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
  programs.zsh.enable = true;
}
