{
  config,
  pkgs,
  lib,
  modulesPath,
  authorizedKeyLists,
  ...
}:

let
  encryptedKey = ''
    -----BEGIN PGP MESSAGE-----

    jA0ECQMKZfP5uVnNOd//0mIB7mc14m7zaN8zlZL5SYvaPbSvmKZypZwybLGFlyN6
    w6CgPLJ+F1WG/dRBCt922ujvCmRYS3jVvpn1Zoo5WG1/HiHU1l/sBGZOTSK1YBZm
    7/EWgKhLVFuBBuipvtY3ZtYI5Q==
    =GlBK
    -----END PGP MESSAGE-----
  '';
in

{
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
    "${
      fetchTarball {
        url = "https://github.com/NixOS/nixos-hardware/tarball/master";
        sha256 = "19cld3jnzxjw92b91hra3qxx41yhxwl635478rqp0k4nl9ak2snq";
      }
    }/raspberry-pi/4"
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "usbhid"
    "usb_storage"
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.kernelParams = [
    "8250.nr_uarts=1"
    "console=ttyAMA0,115200"
    "console=tty1"
    "cma=128M"
  ];

  boot.initrd.postMountCommands = ''
    mkdir -p $targetRoot/etc/wireguard
    echo '${encryptedKey}' | ${pkgs.gnupg}/bin/gpg --decrypt --quiet --batch --passphrase "$(cat /proc/device-tree/serial-number | tr -d '\0')" > $targetRoot/etc/wireguard/private.key
    chmod 400 $targetRoot/etc/wireguard/private.key
    chown root:root $targetRoot/etc/wireguard/private.key
  '';

  documentation.enable = false;
  documentation.nixos.enable = false;
  documentation.man.enable = false;
  documentation.info.enable = false;
  documentation.doc.enable = false;

  services.thermald.enable = false;
  programs.command-not-found.enable = false;
  programs.nano.enable = false;

  environment.defaultPackages = [ ];
  environment.systemPackages = with pkgs; [
    vim
    htop
    util-linux
    gnupg
  ];

  hardware.enableRedistributableFirmware = true;

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "hekate";
  networking.domain = "home";
  networking.extraHosts = "127.0.0.1 hekate.home hekate";
  networking.useDHCP = true;
  networking.firewall.checkReversePath = "loose";
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.0.0.1/24" ];
    listenPort = 51820;
    privateKeyFile = "/etc/wireguard/private.key";
    peers = [
      {
        # iris
        publicKey = "Od72AK2AKZptCZcGJ+PvF78/9EwlFonpWP8X/fCzLGE=";
        allowedIPs = [ "10.0.0.2/32" ];
        persistentKeepalive = 21;
      }
      {
        # pegasus
        publicKey = "/tdJioXk+bkkn0HIATk9t5nMNZMTVqHc3KJA5+vm+w8=";
        allowedIPs = [ "10.0.0.3/32" ];
        persistentKeepalive = 21;
      }
    ];
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      server = [
        "1.1.1.1"
        "8.8.8.8"
      ];
      local = "/home/";
      domain = "home";
      address = [
        "/router.home/10.0.100.1"
        "/herakles.home/10.0.100.97"
        "/hekate.home/10.0.100.110"
        "/pallas.home/10.0.100.204"
      ];
      interface = [
        "wg0"
        "eth0"
      ];
      listen-address = [
        "10.0.0.1"
      ];
    };
  };

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [
      51820
      53
      5353
    ];
    allowedTCPPorts = [
      53
      22
    ];
    extraCommands = ''
      iptables -A FORWARD -i wg0 -o end0 -j ACCEPT
      iptables -A FORWARD -i end0 -o wg0 -m state --state RELATED,ESTABLISHED -j ACCEPT
    '';
    extraStopCommands = ''
      iptables -D FORWARD -i wg0 -o end0 -j ACCEPT 2>/dev/null || true
      iptables -D FORWARD -i end0 -o wg0 -m state --state RELATED,ESTABLISHED -j ACCEPT 2>/dev/null || true
    '';
  };

  networking.nat = {
    enable = true;
    internalInterfaces = [ "wg0" ];
    externalInterface = "end0";
    forwardPorts = [ ];
    extraCommands = ''
      iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o end0 -j MASQUERADE
      iptables -t nat -A PREROUTING -d 10.0.100.0/24 -j NETMAP --to 192.168.1.0/24
    '';
    extraStopCommands = ''
      iptables -t nat -D POSTROUTING -s 10.0.0.0/24 -o end0 -j MASQUERADE 2>/dev/null || true
      iptables -t nat -D PREROUTING -d 10.0.100.0/24 -j NETMAP --to 192.168.1.0/24 2>/dev/null || true
    '';
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  systemd.services."getty@tty1" = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.systemd-networkd-wait-online.enable = false;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
    };
  };

  users.users.moye = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = authorizedKeyLists.moye;
  };

  users.users.root.hashedPassword = "!";

  system.stateVersion = "24.11";
}
