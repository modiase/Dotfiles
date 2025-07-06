{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Moye";
    userEmail = "moyeodiase@gmail.com";
    extraConfig = {
      core.editor = "nvim";
      credential.helper = "vault";
      credential.vault.addr = "http://127.0.0.1:8200";
      credential.vault.path = "secret/data/git";
      filter.lfs.required = true;
      commit.verbose = true;
      rerere.enabled = true;
      gpg.format = "openpgp";
      gpg.openpgp.program = "${pkgs.gnupg}/bin/gpg";
    };
  };
}
