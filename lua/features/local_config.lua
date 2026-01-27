local group = vim.api.nvim_create_augroup("local_config", {})
local local_name = ".nvim.local.lua"
local trust_file = vim.fn.stdpath("data") .. "/trusted"

local f = io.open(trust_file, "a")
if f then f:close() end

local trusted = {}
for line in io.lines(trust_file) do
    trusted[line] = true
end

local function file_hash(filepath)
    local handle = io.popen("sha256sum '" .. filepath .. "' 2>/dev/null")
    if not handle then return nil end
    local result = handle:read("*a")
    handle:close()
    return result:match("^%w+")
end

local function load()
    local cwd = vim.fn.getcwd()
    local local_file = cwd .. "/" .. local_name
    if not io.open(local_file, "r") then
        return
    end

    local hash = file_hash(local_file)
    if trusted[hash] then
        dofile(local_file)
        return
    end

    local answer = vim.fn.input("Trust local config in " .. cwd .. "? (y/N): ")
    if answer:lower() ~= "y" then
        return
    end

    trusted[hash] = true
    local tf = io.open(trust_file, "a")
    tf:write(hash .. "\n")
    tf:close()
    dofile(local_file)
end

vim.api.nvim_create_autocmd("DirChanged", {
    group = group,
    callback = function()
        load()
    end,
})

vim.api.nvim_create_autocmd("VimEnter", {
    group = group,
    callback = function()
        load()
    end,
})
