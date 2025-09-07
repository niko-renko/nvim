vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
})

vim.g.mapleader = " "

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.lsp.buf.format({ timeout_ms = 2000 })
  end,
})
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.server_capabilities.semanticTokensProvider then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

_G.terminal_win = nil

vim.keymap.set('n', '<leader>ti', function()
  vim.cmd('terminal')
  _G.terminal_win = vim.api.nvim_get_current_win()
  vim.cmd('startinsert')
end)

vim.keymap.set('n', '<leader>tt', function()
  if _G.terminal_win and vim.api.nvim_win_is_valid(_G.terminal_win) then
    local current_win = vim.api.nvim_get_current_win()
    if current_win == _G.terminal_win then
      vim.cmd('wincmd p')
    else
      vim.api.nvim_set_current_win(_G.terminal_win)
      vim.cmd('startinsert')
    end
  end
end)

vim.keymap.set('t', '<leader>tt', '<C-\\><C-n><C-w>p')

require("config.lazy")
