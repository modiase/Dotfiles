{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Moye";
    userEmail = "moyeodiase@gmail.com";
    extraConfig = {
      core.editor = "nvim";
      credential.helper = "vault --vault-path-prefix secret/data/git";
      credential.vault.addr = "http://127.0.0.1:8200";
      filter.lfs.required = true;
      commit.verbose = true;
      rerere.enabled = true;
      gpg.format = "openpgp";
      gpg.openpgp.program = "${pkgs.gnupg}/bin/gpg";
    };
  };
}
