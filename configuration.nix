# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = false;  

  boot.kernelParams = [ "modprobe.blacklist=dvb_usb_rtl28xxu" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 1;


  boot.initrd.luks.devices.crypted.device = "/dev/sda1";
  fileSystems."/".device = "/dev/mapper/crypted";

  networking.hostName = "nixos"; # Define your hostname.

  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  #networking.wireless.extraConfig = ''
  # ctrl_interface=/run/wpa_supplicant
  # ctrl_interface_group=wheel
  #'';

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget 
    vim 
    mc 
    fldigi 
    wsjtx 
    libreoffice 
    gnupg 
    gparted 
    firefox 
    pkgs.tdesktop
    pkgs.oathToolkit
    pkgs.networkmanager
    pkgs.networkmanagerapplet
    pkgs.pciutils
    spectacle
    okular
    gwenview
    git
    curl
    gnumake
    unzip
    vlc
    wirelesstools
    nmap
    rsync
    libusb
    rtl-sdr
    gqrx
    dump1090
    cubicsdr
    pkgs.yubikey-manager-qt
    pkgs.yubikey-personalization-gui
    pkgs.ledger-live-desktop
    pkgs.ledger-udev-rules
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization pkgs.libu2f-host pkgs.rtl-sdr ];

  #networking.wireless.userControlled = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [22];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  #hardware.cpu.intel.updateMicrocode = true;

  boot.initrd.kernelModules = [ "i915" ];

  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
  
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.xkbVariant = "";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  # Enable xfce
  #services.xserver.displayManager.defaultSession = "xfce";
  #ervices.xserver.desktopManager.xterm.enable = false;
  #services.xserver.desktopManager.xfce.enable = true;
  # Enable Pantheon
  #services.xserver.desktopManager.pantheon.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "wheel" "tty" "uucp" "dialout" "networkmanager" "audio" ]; # Enable ‘sudo’ for the user.
  };

  # Collect nix store garbage and optimise daily.
  nix.gc.automatic = true;
  nix.optimise.automatic = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  boot.kernel.sysctl =  { "vm.swappiness" = 1; };
  
  services.fstrim.enable = true;
}

