function GitBlameCp()
  vim.api.nvim_exec('GitBlameCopySHA', true);
  print(vim.fn.getreg("+"))
end

vim.api.nvim_set_keymap('n', 'gcs', ':lua GitBlameCp()<CR>', { noremap = true })
