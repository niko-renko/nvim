local local_file = ".nvim.local.lua"
local trust_file = vim.fn.stdpath("data") .. "/trusted"

if vim.fn.filereadable(trust_file) == 0 then
    local f = io.open(trust_file, "w")
    if f then f:close() end
end

local trusted = {}
for line in io.lines(trust_file) do
    trusted[line] = true
end

local cwd = vim.fn.getcwd()
local marker = cwd .. "/" .. local_file

if vim.fn.filereadable(marker) == 1 then
    if trusted[cwd] then
        dofile(marker)
    else
        local answer = vim.fn.input("Trust local config in " .. cwd .. "? (y/N): ")
        if answer:lower() == "y" then
            trusted[cwd] = true
            local f = io.open(trust_file, "a")
            f:write(cwd .. "\n")
            f:close()
            dofile(marker)
        end
    end
end
