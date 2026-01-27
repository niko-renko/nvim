local fzf = require("fzf-lua")

vim.keymap.set("n", "<leader>fn", function()
    local cwd = vim.fn.getcwd() .. "/"
    vim.ui.input({ prompt = "New file: ", default = cwd }, function(path)
        if path and path ~= "" and path ~= cwd then
            local dir = vim.fn.fnamemodify(path, ":h")
            vim.fn.mkdir(dir, "p")
            vim.cmd.edit(path)
        end
    end)
end)

vim.keymap.set("n", "<leader>fm", function()
    fzf.fzf_exec("find . -mindepth 1 \\( -type f -o -type d \\) -not -path '*/.git/*'", {
        prompt = "Move> ",
        actions = {
            ["default"] = function(selected)
                local src = selected[1]:gsub("^%./", "")
                fzf.fzf_exec("find . -type d -not -path '*/.git/*'", {
                    prompt = "Move Destination> ",
                    actions = {
                        ["default"] = function(dest_selected)
                            local dst_dir = dest_selected[1]:gsub("^%./", "")
                            local filename = vim.fn.fnamemodify(src, ":t")
                            local dst = dst_dir .. "/" .. filename
                            vim.fn.rename(src, dst)
                            vim.notify(src .. " -> " .. dst)
                        end
                    }
                })
            end
        }
    })
end)

vim.keymap.set("n", "<leader>fd", function()
    fzf.fzf_exec("find . -mindepth 1 \\( -type f -o -type d \\) -not -path '*/.git/*'", {
        prompt = "Delete> ",
        actions = {
            ["default"] = {
                fn = function(selected)
                    for _, sel in ipairs(selected) do
                        local path = sel:gsub("^%./", "")
                        vim.fn.delete(path, "rf")
                    end
                end,
                reload = true,
            }
        }
    })
end)
