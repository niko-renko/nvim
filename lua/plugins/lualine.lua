return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = { globalstatus = true },
    sections = {
      lualine_c = {
        {
          'filename',
          path = 1
        }
      },
      lualine_x = {
        {
          function()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then
              return ""
            end
            local names = {}
            for _, client in ipairs(clients) do
              local progress = vim.lsp.status()
              if progress and progress ~= "" then
                return progress
              end
              table.insert(names, client.name)
            end
            return table.concat(names, ", ")
          end,
        },
        'filetype',
      },
      lualine_y = {},
    }
  }
}
