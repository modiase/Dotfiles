{
  config,
  lib,
  pkgs,
  authorizedKeyLists,
  commonNixSettings,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    commonNixSettings
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "herakles";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  users.users.moye = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    createHome = true;
    openssh.authorizedKeys.keys = authorizedKeyLists.moye;
  };

  security.sudo.extraRules = [
    {
      users = [ "moye" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [
            "NOPASSWD"
            "SETENV"
          ];
        }
      ];
    }
  ];

  environment.systemPackages = with pkgs; [
    git
    jq
    nix-prefetch
    nvitop
    vim
    wget
    xorg.xauth
  ];

  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
    };
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  networking.firewall.enable = false;

  nixpkgs.config.allowUnfree = true;

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    package = config.hardware.nvidia.package;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    nvidiaSettings = true;
  };

  nixpkgs.config.cudaSupport = true;

  hardware.nvidia-container-toolkit.enable = true;

  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkgKbtJrytuOoQqR5RQY="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  system.stateVersion = "25.05";
  virtualisation.docker.enable = true;
}
