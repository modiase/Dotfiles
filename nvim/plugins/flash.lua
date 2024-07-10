vim.keymap.set("n", "s", function() require("flash").jump() end, { noremap = true })
vim.keymap.set("n", "S", function() require("flash").treesitter() end, { noremap = true })
