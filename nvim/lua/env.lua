---@diagnostic disable-next-line: undefined-global
local vim = vim

if vim.loop.os_uname().sysname == "Darwin" then
	-- security add-generic-password -s "ANTHROPIC_API_KEY" -a "$USER" -w "your-api-key-here"
	vim.env.ANTHROPIC_API_KEY = vim.fn.system('security find-generic-password -s "ANTHROPIC_API_KEY" -a "$USER" -w')
	    :gsub('\n', '')
end
