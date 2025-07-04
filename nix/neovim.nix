{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    extraLuaConfig = builtins.readFile ../nvim/init.lua;
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      {
        plugin = airline;
        config = builtins.readFile ../nvim/lua/plugins/airline.lua;
      }
      {
        plugin = avante-vim;
        config = builtins.readFile ../nvim/lua/plugins/avante.lua;
      }
      {
        plugin = blamer-nvim;
        config = builtins.readFile ../nvim/lua/plugins/blamer.lua;
      }
      {
        plugin = centerpad-nvim;
        config = builtins.readFile ../nvim/lua/plugins/centerpad.lua;
      }
      {
        plugin = coc-nvim;
        config = builtins.readFile ../nvim/lua/plugins/coc.lua;
      }
      {
        plugin = dashboard-nvim;
        config = builtins.readFile ../nvim/lua/plugins/dashboard.lua;
      }
      {
        plugin = diffview-nvim;
        config = builtins.readFile ../nvim/lua/plugins/diffview.lua;
      }
      {
        plugin = flash-nvim;
        config = builtins.readFile ../nvim/lua/plugins/flash.lua;
      }
      {
        plugin = gitgutter;
        config = builtins.readFile ../nvim/lua/plugins/git-gutter.lua;
      }
      {
        plugin = neogit;
        config = builtins.readFile ../nvim/lua/plugins/neogit.lua;
      }
      {
        plugin = neoscroll-nvim;
        config = builtins.readFile ../nvim/lua/plugins/neoscroll.lua;
      }
      {
        plugin = nord-vim;
        config = builtins.readFile ../nvim/lua/plugins/nord.lua;
      }
      {
        plugin = poet-v;
        config = builtins.readFile ../nvim/lua/plugins/poet-v.lua;
      }
      {
        plugin = session-manager;
        config = builtins.readFile ../nvim/lua/plugins/sessionmanager.lua;
      }
      {
        plugin = telescope-nvim;
        config = builtins.readFile ../nvim/lua/plugins/telescope.lua;
      }
      {
        plugin = tmux-nvim;
        config = builtins.readFile ../nvim/lua/plugins/tmux.lua;
      }
      {
        plugin = vim-bbye;
        config = builtins.readFile ../nvim/lua/plugins/vim-bbye.lua;
      }
      {
        plugin = vim-rooter;
        config = builtins.readFile ../nvim/lua/plugins/vim-rooter.lua;
      }
      {
        plugin = which-key-nvim;
        config = builtins.readFile ../nvim/lua/plugins/which-key.lua;
      }
      {
        plugin = winresize-nvim;
        config = builtins.readFile ../nvim/lua/plugins/winresize.lua;
      }
    ];
  };
}
