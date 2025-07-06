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
  gemini-cli
  gnused
  gtop 
  httpie 
  jq
  
  jwt-cli
  
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
