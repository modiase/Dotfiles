{ pkgs }:

with pkgs; [
  cargo
  claude-code
  coreutils
  direnv
  docker 
  fd 
  fzf 
  google-cloud-sdk
  gcc 
  gemini-cli
  gnused
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
  tree
  tshark
  uv
  watch
]
