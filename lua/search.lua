local ns = vim.api.nvim_create_namespace("search_counter")
local current_match_line = nil

-- highlight group
vim.api.nvim_set_hl(0, "SearchCounter", { fg = "#ffaf00", bold = true })

local function update_search_virtual_text()
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
    local sc = vim.fn.searchcount({ maxcount = 9999 })
    if sc.total == 0 or sc.current == 0 then
        current_match_line = nil
        return
    end

    local pos = vim.fn.searchpos(vim.fn.getreg("/"), "c")
    if pos[1] == 0 then
        current_match_line = nil
        return
    end

    current_match_line = pos[1] - 1
    vim.api.nvim_buf_set_extmark(0, ns, current_match_line, 0, {
        virt_text = { { string.format("[%d/%d]", sc.current, sc.total), "SearchCounter" } },
        virt_text_pos = "eol",
    })
end

_G.update_search_virtual_text = update_search_virtual_text

-- n/N mappings
vim.keymap.set("n", "n", "n:lua update_search_virtual_text()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "N", "N:lua update_search_virtual_text()<CR>", { noremap = true, silent = true })

-- first hit after / or ?
vim.api.nvim_create_autocmd("CmdlineLeave", {
    pattern = { "/", "?" },
    callback = function()
        vim.schedule(update_search_virtual_text)
    end,
})

-- clear virtual text when leaving match line
vim.api.nvim_create_autocmd("CursorMoved", {
    callback = function()
        if current_match_line and vim.api.nvim_win_get_cursor(0)[1] - 1 ~= current_match_line then
            vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
            current_match_line = nil
        end
    end,
})
