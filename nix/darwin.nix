{ pkgs, ... }:

{
  imports = [
  ];

  home.packages = with pkgs; [
    colima
    coreutils-prefixed
    iproute2mac
  ];
}
