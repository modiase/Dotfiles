{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    functions = {
      _fzf_configure_bindings_help = (builtins.readFile /Users/moye/Dotfiles/fish/functions/_fzf_configure_bindings_help.fish);
      _fzf_extract_var_info = (builtins.readFile /Users/moye/Dotfiles/fish/functions/_fzf_extract_var_info.fish);
      _fzf_preview_changed_file = (builtins.readFile /Users/moye/Dotfiles/fish/functions/_fzf_preview_changed_file.fish);
      _fzf_preview_file = (builtins.readFile /Users/moye/Dotfiles/fish/functions/_fzf_preview_file.fish);
      _fzf_report_diff_type = (builtins.readFile /Users/moye/Dotfiles/fish/functions/_fzf_report_diff_type.fish);
      _fzf_report_file_type = (builtins.readFile /Users/moye/Dotfiles/fish/functions/_fzf_report_file_type.fish);
      _fzf_search_directory = (builtins.readFile /Users/moye/Dotfiles/fish/functions/_fzf_search_directory.fish);
      _fzf_search_git_log = (builtins.readFile /Users/moye/Dotfiles/fish/functions/_fzf_search_git_log.fish);
      _fzf_search_git_status = (builtins.readFile /Users/moye/Dotfiles/fish/functions/_fzf_search_git_status.fish);
      _fzf_search_history = (builtins.readFile /Users/moye/Dotfiles/fish/functions/_fzf_search_history.fish);
      _fzf_search_processes = (builtins.readFile /Users/moye/Dotfiles/fish/functions/_fzf_search_processes.fish);
      _fzf_search_variables = (builtins.readFile /Users/moye/Dotfiles/fish/functions/_fzf_search_variables.fish);
      _fzf_wrapper = (builtins.readFile /Users/moye/Dotfiles/fish/functions/_fzf_wrapper.fish);
      bind_bang = (builtins.readFile /Users/moye/Dotfiles/fish/functions/bind_bang.fish);
      bind_dollar = (builtins.readFile /Users/moye/Dotfiles/fish/functions/bind_dollar.fish);
      envsource = (builtins.readFile /Users/moye/Dotfiles/fish/functions/envsource.fish);
      fish_prompt = (builtins.readFile /Users/moye/Dotfiles/fish/functions/fish_prompt.fish);
      fish_right_prompt = (builtins.readFile /Users/moye/Dotfiles/fish/functions/fish_right_prompt.fish);
      fish_user_key_bindings = (builtins.readFile /Users/moye/Dotfiles/fish/functions/fish_user_key_bindings.fish);
      fisher = (builtins.readFile /Users/moye/Dotfiles/fish/functions/fisher.fish);
      fzf_configure_bindings = (builtins.readFile /Users/moye/Dotfiles/fish/functions/fzf_configure_bindings.fish);
      gbr = (builtins.readFile /Users/moye/Dotfiles/fish/functions/gbr.fish);
      git_ahead = (builtins.readFile /Users/moye/Dotfiles/fish/functions/git_ahead.fish);
      git_branch_name = (builtins.readFile /Users/moye/Dotfiles/fish/functions/git_branch_name.fish);
      git_is_dirty = (builtins.readFile /Users/moye/Dotfiles/fish/functions/git_is_dirty.fish);
      git_is_repo = (builtins.readFile /Users/moye/Dotfiles/fish/functions/git_is_repo.fish);
      git_is_staged = (builtins.readFile /Users/moye/Dotfiles/fish/functions/git_is_staged.fish);
      git_is_stashed = (builtins.readFile /Users/moye/Dotfiles/fish/functions/git_is_stashed.fish);
      git_is_touched = (builtins.readFile /Users/moye/Dotfiles/fish/functions/git_is_touched.fish);
      git_is_worktree = (builtins.readFile /Users/moye/Dotfiles/fish/functions/git_is_worktree.fish);
      git_untracked = (builtins.readFile /Users/moye/Dotfiles/fish/functions/git_untracked.fish);
      isodate = (builtins.readFile /Users/moye/Dotfiles/fish/functions/isodate.fish);
      "jira-profile" = (builtins.readFile /Users/moye/Dotfiles/fish/functions/jira-profile.fish);
      jira = (builtins.readFile /Users/moye/Dotfiles/fish/functions/jira.fish);
      lg = (builtins.readFile /Users/moye/Dotfiles/fish/functions/lg.fish);
      pynix = (builtins.readFile /Users/moye/Dotfiles/fish/functions/pynix.fish);
      ren = (builtins.readFile /Users/moye/Dotfiles/fish/functions/ren.fish);
      sandbox = (builtins.readFile /Users/moye/Dotfiles/fish/functions/sandbox.fish);
      timestamp = (builtins.readFile /Users/moye/Dotfiles/fish/functions/timestamp.fish);
      touch2 = (builtins.readFile /Users/moye/Dotfiles/fish/functions/touch2.fish);
      watchheader = (builtins.readFile /Users/moye/Dotfiles/fish/functions/watchheader.fish);
      with_env = (builtins.readFile /Users/moye/Dotfiles/fish/functions/with_env.fish);
    };
    shellAliases = {
      gadd = "git add";
      gamd = "git commit --amend --no-edit";
      gblg = "git reflog show (git branch --show)";
      gci = "git commit";
      gco = "git checkout";
      gcp = "git cherry-pick";
      gdff = "git diff";
      gfch = "git fetch";
      ggc = "git gc";
      ggrep = "git grep";
      ggrph = "git log --all --decorate --oneline --graph";
      ghm = "test \"(git branch --show)\" = \"(git symbolic-ref --short HEAD)\" or git checkout (git symbolic-ref --short HEAD)";
      glg = "git log --oneline";
      gls = "git ls-files";
      gmb = "git merge-base";
      gmrg = "git merge";
      gpath = "git status &>/dev/null; and python -c 'import sys;assert len(sys.argv) >= 3, \"Missing argument\";from pathlib import Path;print(Path(sys.argv[2]).absolute().relative_to(Path(sys.argv[1])))' (git rev-parse --show-toplevel)";
      gpll = "git pull";
      gpsh = "git push";
      gpwd = "git status &>/dev/null; and python -c 'import sys;from pathlib import Path;print(Path(sys.argv[2]).relative_to(Path(sys.argv[1])))' (git rev-parse --show-toplevel) (pwd)";
      grb = "git rebase";
      grbi = "git rebase -i (git merge-base HEAD (git symbolic-ref --short refs/remotes/origin/HEAD | cut -d '/' -f2))";
      grbm = "git rebase (git symbolic-ref --short refs/remotes/origin/HEAD | cut -d '/' -f2)";
      grlg = "git reflog";
      grm = "git rm";
      grmt = "git remote";
      grst = "git reset";
      grsto = "git restore";
      grt = "git rev-parse --show-toplevel &>/dev/null; and cd (git rev-parse --show-toplevel) or echo \"Not in a git repo\"";
      grv = "git revert";
      gsbtr = "git subtree";
      gshow = "git show";
      gst = "git status";
      gstsh = "git stash";
      gsw = "git switch";
      gtag = "git tag";
      gtch = "GIT_COMMITTER_DATE=\"(date)\" git commit --amend --no-edit --date \"(date)\"";
      gupd = "git fetch origin main:main; and git rebase main";
      gwhich = "git branch --show";
      gwt = "git worktree";
    };
    shellAbbrs = {
      csv2json = "python -c 'import csv, json, sys; print(json.dumps([dict(r) for r in csv.DictReader(sys.stdin)]))'";
    };
    shellInit = ''
      set -gx DOTFILES \"$HOME/Dotfiles\"
      set -gx MANPAGER \"nvim +Man!\"
    '';
    interactiveShellInit = ''
      function change_directory
          if test -d .git
              set -f _is_git_repo true
          else
              begin
                set -l info (command git rev-parse --git-dir --is-bare-repository 2>/dev/null)
                if set -q info[2]; and test $info[2] = false
                    set -f _is_git_repo true
                else
                    set -f _is_git_repo false
                end
              end
          end
          if test $_is_git_repo = true
            set -f root (git rev-parse --show-toplevel)
          else
            set -f root (pwd)
          end
          cd (cat (echo $root | psub) (fd . --type d $root | psub) | fzf; or echo '.')
      end

      fish_user_key_bindings
      bind \cs change_directory
      set -gx fish_greeting \"\"
    '';
  };
}
