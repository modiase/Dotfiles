-- -- Find files using Telescope command-line sugar.
vim.api.nvim_set_keymap("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
  { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>ft', '<cmd>Telescope help_tags<cr>', { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>fw",
  ":lua require('telescope-live-grep-args.shortcuts').grep_word_under_cursor()<CR>", { noremap = true })
