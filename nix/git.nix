{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Moye";
    userEmail = "moyeodiase@gmail.com";
    extraConfig = {
      core.editor = "nvim";
      credential.helper = "osxkeychain";
      filter.lfs.required = true;
      commit.verbose = true;
      rerere.enabled = true;
      gpg.format = "openpgp";
      gpg.openpgp.program = "${pkgs.gnupg}/bin/gpg";
    };
  };
}
