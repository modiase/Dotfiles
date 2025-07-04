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
    };
    aliases = {
      gadd = "add";
      gamd = "commit --amend --no-edit";
      gblg = "reflog show $(git branch --show)";
      gci = "commit";
      gco = "checkout";
      gcp = "cherry-pick";
      gdff = "diff";
      gfch = "fetch";
      ggc = "gc";
      ggrep = "grep";
      ggrph = "log --all --decorate --oneline --graph";
      ghm = "!test \"$(git branch --show)\" = \"$(git symbolic-ref --short HEAD)\" || git checkout $(git symbolic-ref --short HEAD)";
      glg = "log --oneline";
      gls = "ls-files";
      gmb = "merge-base";
      gmrg = "merge";
      gpath = "!git status &>/dev/null && python -c 'import sys;assert len(sys.argv) >= 3, \"Missing argument\";from pathlib import Path;print(Path(sys.argv[2]).absolute().relative_to(Path(sys.argv[1])))' (git rev-parse --show-toplevel)";
      gpll = "pull";
      gpsh = "push";
      gpwd = "!git status &>/dev/null && python -c 'import sys;from pathlib import Path;print(Path(sys.argv[2]).relative_to(Path(sys.argv[1])))' (git rev-parse --show-toplevel) (pwd)";
      grb = "rebase";
      grbi = "!git rebase -i (git merge-base HEAD (git symbolic-ref --short refs/remotes/origin/HEAD | cut -d '/' -f2))";
      grbm = "!git rebase (git symbolic-ref --short refs/remotes/origin/HEAD | cut -d '/' -f2)";
      grlg = "reflog";
      grm = "rm";
      grmt = "remote";
      grst = "reset";
      grsto = "restore";
      grt = "!git rev-parse --show-toplevel &>/dev/null && cd (git rev-parse --show-toplevel) || echo \"Not in a git repo\"";
      grv = "revert";
      gsbtr = "subtree";
      gshow = "show";
      gst = "status";
      gstsh = "stash";
      gsw = "switch";
      gtag = "tag";
      gtch = "!GIT_COMMITTER_DATE=\"$(date)\" git commit --amend --no-edit --date \"$(date)\"";
      gupd = "!git fetch origin main:main && git rebase main";
      gwhich = "branch --show";
      gwt = "worktree";
    };
  };
}
