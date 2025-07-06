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
  nix-prefetch-git
  nix-tree
  nodePackages.pnpm
  nodePackages.ts-node
  nodePackages.typescript
  nodejs
  pass
  pass-git-helper
  poetry
  pstree
  (python313.withPackages (ps: with ps; [
    boto3
    ipython
    matplotlib
    numpy
    pandas
  ]))
  pstree
  ripgrep
  tldr
  tmux
  tree
  tshark
  uv
  watch
]
