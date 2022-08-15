local home = os.getenv('HOME')
local db = require('dashboard')

db.custom_header = {
 ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
 ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
 ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
 ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
 ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
 ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
}
db.preview_file_height = 12
db.preview_file_width = 80
db.center_pad = 5
db.custom_center = {
  {icon = '  ',
  desc = 'Open New File                              ',
  action = 'DashboardNewFile',
  shortcut = 'SPC f d'},
  {icon = '  ',
  desc = 'Open Latest Session                        ',
  shortcut = 'SPC s l',
  action ='SessionLoad'},
  {icon = '  ',
  desc = 'Show Help                                  ',
  action =  'Telescope help_tags',
  shortcut = 'SPC f h'},
  {icon = '  ',
  desc = 'Find  File                                 ',
  action = 'Telescope find_files find_command=rg,--hidden,--files',
  shortcut = 'SPC f f'},
  {icon = ' ',
  desc ='Open Explorer                               ',
  action =  'CocCommand explorer --focus --position floating',
  shortcut = 'SPC e e'},
  {icon = '﬘ ',
  desc ='Browse Buffers                              ',
  action =  'Telescope buffers',
  shortcut = 'SPC f b'},
  {icon = '  ',
  desc = 'Live Grep                                  ',
  action = 'Telescope live_grep',
  shortcut = 'SPC f g'},
} 
db.custom_footer = {}
db.session_directory = home .. '/.vim/sessions'

vim.api.nvim_set_keymap('n', '<Leader>ss', '<cmd>SessionSave<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>sl', '<cmd>SessionLoad<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fh', '<cmd>Telescope help_tags<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fh', '<cmd>Telescope help_tags<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>ff', '<cmd>Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>tc', '<cmd>Telescope colorscheme<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>cn', '<cmd>DashboardNewFile<CR>', { noremap = true, silent = true })

vim.api.nvim_command('autocmd VimLeave * :SessionSave')
