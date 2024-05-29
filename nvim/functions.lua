function FullPathCp()
	-- Get the full path of the current file
	local abs_path = vim.fn.expand('%:p')
	print(abs_path)
	vim.fn.setreg('+', abs_path, c)
end

vim.api.nvim_set_keymap('n', 'cp', ':lua FullPathCp()<CR>', { noremap = true })

function GitAwareCp()
	-- Get the full path of the current file
	local file_path = vim.fn.expand('%:p')

	-- Separate the path into directory and trailing file component
	local dir_path = vim.fn.fnamemodify(file_path, ':h')

	-- Iterate up through directory structure
	while dir_path ~= '/' and dir_path ~= '.' do
		-- Check for .git directory or file
		if vim.fn.isdirectory(dir_path .. '/.git') == 1 then
			-- Found .git, compute relative path
			local relative_path = vim.fn.fnamemodify(file_path, ':.')
			print(relative_path)
			vim.fn.setreg('+', relative_path, c)
			return
		else
			-- Move up one directory level
			dir_path = vim.fn.fnamemodify(dir_path, ':h')
		end
	end

	print("No git directory found in hierarchy")
end

vim.api.nvim_set_keymap('n', 'gcp', ':lua GitAwareCp()<CR>', { noremap = true })

function SwapWithLeftBuffer()
	-- Get the current buffer and window ID
	local current_win = vim.api.nvim_get_current_win()
	local current_buf = vim.api.nvim_win_get_buf(current_win)

	-- Find the total number of windows
	local windows = vim.api.nvim_list_wins()
	local current_index = nil
	for i, win in ipairs(windows) do
		if win == current_win then
			current_index = i
			break
		end
	end

	-- Only swap if there is a window to the left
	if current_index == nil or current_index == 1 then
		print("No window to the left to swap with")
		return
	end

	local left_win = windows[current_index - 1]
	local left_buf = vim.api.nvim_win_get_buf(left_win)

	-- Swap the buffers
	vim.api.nvim_win_set_buf(current_win, left_buf)
	vim.api.nvim_win_set_buf(left_win, current_buf)
	vim.api.nvim_set_current_win(left_win)
end

-- To use this command directly in Neovim, map it to a desired keybinding:
vim.api.nvim_set_keymap('n', '<C-w><C-h>', ':lua SwapWithLeftBuffer()<CR>', { noremap = true, silent = true })

function SwapWithRightBuffer()
	-- Get the current buffer and window ID
	local current_win = vim.api.nvim_get_current_win()
	local current_buf = vim.api.nvim_win_get_buf(current_win)

	-- Find the total number of windows
	local windows = vim.api.nvim_list_wins()
	local current_index = nil
	for i, win in ipairs(windows) do
		if win == current_win then
			current_index = i
			break
		end
	end

	-- Only swap if there is a window to the right
	if current_index == nil or current_index == #windows then
		print("No window to the right to swap with")
		return
	end

	local right_win = windows[current_index + 1]
	local right_buf = vim.api.nvim_win_get_buf(right_win)

	-- Swap the buffers
	vim.api.nvim_win_set_buf(current_win, right_buf)
	vim.api.nvim_win_set_buf(right_win, current_buf)
	vim.api.nvim_set_current_win(right_win)
end

vim.api.nvim_set_keymap('n', '<C-w><C-l>', ':lua SwapWithRightBuffer()<CR>', { noremap = true, silent = true })

function GetWindowsDisplayingBuffer(bufnr)
	local windows_displaying_buffer = {}
	-- Loop over all tabpages
	for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
		-- Get all windows in the current tabpage
		local windows = vim.api.nvim_tabpage_list_wins(tabpage)
		-- Check each window to see if it's displaying the specified buffer
		for _, win in ipairs(windows) do
			if vim.api.nvim_win_get_buf(win) == bufnr then
				table.insert(windows_displaying_buffer, win)
			end
		end
	end
	return windows_displaying_buffer
end

function CloseBufferWindow(config)
	config = config or {}
	local force = config.force or false

	local bufnr = vim.api.nvim_get_current_buf()
	local winnr = vim.api.nvim_get_current_win()
	local windows = GetWindowsDisplayingBuffer(bufnr)

	if #windows == 1
	then
		local success, _ = pcall(vim.api.nvim_buf_delete, bufnr, { force = force })
		if not success
		then
			print("Could not close window")
		end
	else
		vim.api.nvim_win_close(winnr, { force = force })
	end
end

vim.api.nvim_set_keymap('n', '<leader>x', ':lua CloseBufferWindow()<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>X', ':lua CloseBufferWindow({ force = true })<CR>',
	{ noremap = true, silent = true })

