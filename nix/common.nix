{ pkgs }:

with pkgs; [
 bat
  cargo
  coreutils
  direnv
  docker 
  fd 
  fzf 
  google-cloud-sdk
  gcc 
  gnused
  gtop 
  httpie 
  jq
  jupyter
  jwt-cli
  neovim
  nix-tree
  nodejs 
  pstree 
  (python313.withPackages (ps: with ps; [
	boto3
    ipython
    matplotlib
    numpy
    pandas
  ]))
  ripgrep 
  tldr 
  tmux 
  tree
  tshark
  nix-prefetch-git
  nodePackages.pnpm
  nodePackages.ts-node
  nodePackages.typescript 
  uv
  watch
]
