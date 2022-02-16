{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  programs.steam.enable = true;
   imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "nixos";

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.emacs.package = pkgs.emacsUnstable;

  nixpkgs.overlays = [
    (import ./firefox-overlay.nix) # might change this to be a relative path
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))

  # sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  fonts.fonts = with pkgs; [
     fira-code
     fira-code-symbols
     ibm-plex
     jetbrains-mono
     julia-mono
     roboto-mono
     source-serif
  ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako # notification daemon
      wofi
    ];
  };

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";

  services.xserver.desktopManager.plasma5.enable = true;

   users.users.jane = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
   };

  environment.systemPackages = with pkgs; [
     wget
     latest.firefox-nightly-bin
     emacsGit
     git
     aspell
     aspellDicts.en
     keepassxc
     vlc
     sqlite
     pandoc
     ffmpeg
     pamixer
     gcc
     p7zip
     ripgrep
     hugo
     sassc
     nodePackages.vercel
     ninja
     gh
     chromium
     python38Full
     wineWowPackages.staging
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # I use X11 only for networked connections
  services.openssh.forwardX11 = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}

