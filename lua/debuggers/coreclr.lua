local dap = require("dap")

---@param csproj_path string
---@return string|nil
local function get_dll_from_csproj(csproj_path)
    local content = table.concat(vim.fn.readfile(csproj_path), "\n")

    local output_type = content:match("<OutputType>([^<]+)</OutputType>")
    if output_type and output_type:lower() ~= "exe" then
        return nil
    end

    local assembly_name = content:match("<AssemblyName>([^<]+)</AssemblyName>")
        or vim.fn.fnamemodify(csproj_path, ":t:r")

    local target_framework = content:match("<TargetFramework>([^<]+)</TargetFramework>")
    if not target_framework then
        local frameworks = content:match("<TargetFrameworks>([^<]+)</TargetFrameworks>")
        if frameworks then
            target_framework = vim.split(frameworks, ";")[1]
        end
    end

    if not target_framework then
        return nil
    end

    local project_dir = vim.fn.fnamemodify(csproj_path, ":h")
    local dll_path = string.format("%s/bin/Debug/%s/%s.dll", project_dir, target_framework, assembly_name)

    if vim.fn.filereadable(dll_path) == 1 then
        return dll_path
    end

    return nil
end

---@return string|nil
local function find_dll()
    local cwd = vim.fn.getcwd()
    local csproj_files = vim.fn.glob(cwd .. "/**/*.csproj", false, true)

    if #csproj_files == 0 then
        return vim.fn.input("Path to dll: ", cwd .. "/bin/Debug/", "file")
    end

    local exe_projects = {}
    for _, csproj in ipairs(csproj_files) do
        local dll = get_dll_from_csproj(csproj)
        if dll then
            table.insert(exe_projects, {
                dll = dll,
                name = vim.fn.fnamemodify(csproj, ":t:r"),
            })
        end
    end

    if #exe_projects == 0 then
        return vim.fn.input("Path to dll: ", cwd .. "/bin/Debug/", "file")
    elseif #exe_projects == 1 then
        return exe_projects[1].dll
    end

    local items = {}
    for _, proj in ipairs(exe_projects) do
        table.insert(items, proj.name)
    end

    local choice = vim.fn.inputlist(vim.list_extend({ "Select project to debug:" }, items))
    if choice > 0 and choice <= #exe_projects then
        return exe_projects[choice].dll
    end

    return nil
end


dap.adapters.coreclr = {
    type = "executable",
    command = "netcoredbg",
    args = { "--interpreter=vscode" },
}

dap.configurations.cs = {
    {
        type = "coreclr",
        name = "Launch",
        request = "launch",
        program = find_dll,
    },
}
