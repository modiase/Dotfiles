---@diagnostic disable-next-line: undefined-global
local vim = vim
return {
	'neoclide/coc.nvim',
	branch = 'release',
	event = 'VeryLazy',
	config = function()
		-- vim options
		vim.opt.hidden = true
		vim.opt.backup = false
		vim.opt.writebackup = false
		vim.opt.cmdheight = 2
		vim.opt.updatetime = 300
		vim.opt.shortmess:append('c')
		vim.opt.signcolumn = 'yes'

		-- Helper function to check backspace
		local function check_back_space()
			local col = vim.fn.col('.') - 1
			return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
		end

		-- Global CoC settings
		vim.g.coc_snippet_next = '<tab>'

		-- Diagnostic navigation
		vim.keymap.set('n', '[g', '<Plug>(coc-diagnostic-prev)', { silent = true })
		vim.keymap.set('n', ']g', '<Plug>(coc-diagnostic-next)', { silent = true })

		-- Code navigation mappings
		vim.keymap.set('n', 'gd', '<Plug>(coc-definition)', { silent = true })
		vim.keymap.set('n', 'gs', ':sp<CR><C-j><Plug>(coc-definition)', { silent = true })
		vim.keymap.set('n', 'gv', ':vs<CR><C-l><Plug>(coc-definition)', { silent = true })
		vim.keymap.set('n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
		vim.keymap.set('n', 'gx', ':vs<CR><C-l><Plug>(coc-type-definition)', { silent = true })
		vim.keymap.set('n', 'gz', ':sp<CR><C-j><Plug>(coc-type-definition)', { silent = true })
		vim.keymap.set('n', 'gi', '<Plug>(coc-implementation)', { silent = true })
		vim.keymap.set('n', 'gr', '<Plug>(coc-references)', { silent = true })

		-- Show documentation function
		local function show_documentation()
			local filetype = vim.bo.filetype
			if vim.tbl_contains({ 'vim', 'help' }, filetype) then
				vim.cmd('h ' .. vim.fn.expand('<cword>'))
			else
				vim.fn.CocAction('doHover')
			end
		end

		-- Documentation keymap
		vim.keymap.set('n', 'K', show_documentation, { silent = true })

		-- Highlight symbol under cursor
		vim.api.nvim_create_autocmd('CursorHold', {
			pattern = '*',
			callback = function()
				vim.fn.CocActionAsync('highlight')
			end
		})

		-- Rename and format mappings
		vim.keymap.set('n', '<leader>rn', '<Plug>(coc-rename)')
		vim.keymap.set('x', '<leader>f', '<Plug>(coc-format-selected)')
		vim.keymap.set('n', '<leader>f', '<Plug>(coc-format-selected)')

		-- Setup formatexpr for specific filetypes
		vim.api.nvim_create_augroup('mygroup', {})
		vim.api.nvim_create_autocmd('FileType', {
			group = 'mygroup',
			pattern = { 'typescript', 'json' },
			callback = function()
				vim.opt_local.formatexpr = "CocAction('formatSelected')"
			end
		})

		-- Update signature help on placeholder jump
		vim.api.nvim_create_autocmd('User', {
			group = 'mygroup',
			pattern = 'CocJumpPlaceholder',
			callback = function()
				vim.fn.CocActionAsync('showSignatureHelp')
			end
		})

		-- Code action mappings
		vim.keymap.set('x', '<leader>a', '<Plug>(coc-codeaction-selected)')
		vim.keymap.set('n', '<leader>a', '<Plug>(coc-codeaction-selected)')
		vim.keymap.set('n', '<leader>ac', '<Plug>(coc-codeaction)')
		vim.keymap.set('n', '<leader>qf', '<Plug>(coc-fix-current)')
		vim.keymap.set('x', '<S-TAB>', '<Plug>(coc-range-select-backword)', { silent = true })

		-- Add commands
		vim.api.nvim_create_user_command('Format', "call CocAction('format')", {})
		vim.api.nvim_create_user_command('Fold', "call CocAction('fold', <f-args>)", { nargs = '?' })
		vim.api.nvim_create_user_command('OR', "call CocAction('runCommand', 'editor.action.organizeImport')", {})


		-- CocList mappings
		local coclist_mappings = {
			{ 'a', 'diagnostics', 'Show all diagnostics' },
			{ 'e', 'extensions',  'Manage extensions' },
			{ 'c', 'commands',    'Show commands' },
			{ 'o', 'outline',     'Find symbol of current document' },
			{ 's', '-I symbols',  'Search workspace symbols' },
			{ 'j', 'next',        'Do default action for next item' },
			{ 'k', 'prev',        'Do default action for previous item' },
			{ 'p', 'resume',      'Resume latest coc list' }
		}

		for _, mapping in ipairs(coclist_mappings) do
			local key, cmd, desc = unpack(mapping)
			vim.keymap.set('n', '<space>' .. key,
				string.format(':<C-u>CocList %s<CR>', cmd),
				{ silent = true, desc = desc })
		end

		-- Explorer mappings
		vim.keymap.set('n', '<space>ee', ':CocCommand explorer --focus --position floating<CR>',
			{ silent = true })
		vim.keymap.set('n', '<space>ef', ':CocCommand explorer --focus --position floating --no-toggle<CR>',
			{ silent = true })

		-- Diagnostic navigation
		vim.keymap.set('n', '<leader>en', function() vim.fn.CocAction('diagnosticNext') end, { silent = true })
		vim.keymap.set('n', '<leader>ep', function() vim.fn.CocAction('diagnosticPrevious') end,
			{ silent = true })

		-- CoC extensions
		vim.g.coc_global_extensions = {
			'@yaegassy/coc-ruff', 'coc-clangd', 'coc-css', 'coc-emmet', 'coc-eslint',
			'coc-explorer', 'coc-html', 'coc-json', 'coc-lua', 'coc-prettier', 'coc-pyright',
			'coc-sh', 'coc-snippets', 'coc-tsserver', 'coc-vimlsp',
		}

		-- Insert mode mappings
		vim.keymap.set('i', '<S-TAB>', function()
			if vim.fn['coc#pum#visible']() then
				return vim.fn['coc#_select_confirm']()
			elseif vim.fn['coc#expandableOrJumpable']() then
				return vim.fn['coc#rpc#request']('doKeymap', { 'snippets-expand-jump', '' })
			elseif check_back_space() then
				return '<TAB>'
			else
				return vim.fn['coc#refresh']()
			end
		end, { expr = true, silent = true })

		-- Local config and range selection
		vim.keymap.set('n', '<leader>cc', ':CocLocalConfig<cr>', { silent = true })
		vim.keymap.set('n', '<S-TAB>', '<Plug>(coc-range-select)', { silent = true })
		vim.keymap.set('x', '<S-TAB>', '<Plug>(coc-range-select)', { silent = true })
	end

}
