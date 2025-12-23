local M = {}

local watchers = {}

function M.stop_watch_file(bufnr)
    if watchers[bufnr] then
        watchers[bufnr]:stop()
        watchers[bufnr] = nil
    end
end

function M.watch_file(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local filepath = vim.api.nvim_buf_get_name(bufnr)
    if filepath == "" then return end

    if watchers[bufnr] then
        watchers[bufnr]:stop()
    end

    local w = vim.uv.new_fs_poll()
    w:start(filepath, 1000, vim.schedule_wrap(function(err)
        if err or not vim.api.nvim_buf_is_valid(bufnr) then return end
        vim.api.nvim_buf_call(bufnr, function()
            vim.cmd("checktime")
        end)
    end))
    watchers[bufnr] = w
end

return M
