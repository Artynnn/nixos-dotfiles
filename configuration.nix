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

  # networking.hostName = "nixos"; # Define your hostname.

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
  #  (import (builtins.fetchGit {
  #    url = "https://github.com/nix-community/emacs-overlay.git";
  #    ref = "master";
  #    # prev: 29.0.50
  #    rev = "43fadd1cc5db73a27c52ecbdaa1a7f45a50908fb"; # change the revision
  #  }))
  ];

  # SOUND
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
    # might change this to foot or kitty
    alacritty # Alacritty is the default terminal in the config
    dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
  ];
};

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";


  services.xserver.desktopManager.plasma5.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.jane = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
   };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     latest.firefox-nightly-bin
     emacsGit
     git
     aspell
     aspellDicts.en
     keepassxc
     vlc
     sqlite
     emacs27Packages.emacsql-sqlite
     pandoc
     ffmpeg
     pamixer
     gcc

     p7zip
     
     love_11
     alda
     love
     fennel
     gimp
     gnumake

     nicotine-plus
     soulseekqt

     ripgrep

     hugo

     sassc
     nodePackages.vercel

     ninja
     gh

     chromium

     hikari
     wio
     swaybg
     river
#
#     python39Full
     python38Full

     #     (wine.override { wineBuild = "wine64"; })
     # wine-staging (version with experimental features)
     wineWowPackages.staging
 
     # winetricks and other programs depending on wine need to use the same wine version
#     (winetricks.override { wine = wineWowPackages.staging; })

  ];

#   programs.java = { enable = true; package = pkgs.oraclejre8; };

#services.syncthing = {
 # enable = true;
#  dataDir = "/home/jane";
#  openDefaultPorts = true;
#  configDir = "/home/wk/.config/syncthing";
#  user = "jane";
#  group = "users";
#  guiAddress = "0.0.0.0:8384";
#  declarative = { SNIPPED };
#};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
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

