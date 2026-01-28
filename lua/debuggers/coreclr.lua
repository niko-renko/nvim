local dap = require("dap")

local netcoredbg_path = vim.fn.exepath("netcoredbg")
if netcoredbg_path == "" then
    -- Try Mason path
    netcoredbg_path = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg"
end

dap.adapters.coreclr = {
    type = "executable",
    command = netcoredbg_path,
    args = { "--interpreter=vscode" },
}

--- Parse .csproj file and extract DLL path
---@param csproj_path string
---@return string|nil
local function get_dll_from_csproj(csproj_path)
    local content = table.concat(vim.fn.readfile(csproj_path), "\n")

    -- Check if it's an executable project
    local output_type = content:match("<OutputType>([^<]+)</OutputType>")
    if output_type and output_type:lower() ~= "exe" then
        return nil -- Skip library projects
    end

    -- Get assembly name (defaults to project file name)
    local assembly_name = content:match("<AssemblyName>([^<]+)</AssemblyName>")
    if not assembly_name then
        assembly_name = vim.fn.fnamemodify(csproj_path, ":t:r")
    end

    -- Get target framework
    local target_framework = content:match("<TargetFramework>([^<]+)</TargetFramework>")
    if not target_framework then
        -- Try TargetFrameworks (plural) and take first one
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

--- Find the DLL for the current project
---@return string|nil
local function find_dll()
    local cwd = vim.fn.getcwd()

    -- Find all .csproj files
    local csproj_files = vim.fn.glob(cwd .. "/**/*.csproj", false, true)

    if #csproj_files == 0 then
        return vim.fn.input("Path to dll: ", cwd .. "/bin/Debug/", "file")
    end

    -- Find executable projects with built DLLs
    local exe_projects = {}
    for _, csproj in ipairs(csproj_files) do
        local dll = get_dll_from_csproj(csproj)
        if dll then
            table.insert(exe_projects, {
                csproj = csproj,
                dll = dll,
                name = vim.fn.fnamemodify(csproj, ":t:r"),
            })
        end
    end

    if #exe_projects == 0 then
        return vim.fn.input("Path to dll: ", cwd .. "/bin/Debug/", "file")
    elseif #exe_projects == 1 then
        return exe_projects[1].dll
    else
        -- Multiple executable projects, let user pick
        local items = {}
        for _, proj in ipairs(exe_projects) do
            table.insert(items, proj.name)
        end

        local choice = vim.fn.inputlist(
            vim.list_extend({ "Select project to debug:" }, items)
        )

        if choice > 0 and choice <= #exe_projects then
            return exe_projects[choice].dll
        end

        return nil
    end
end

dap.configurations.cs = {
    {
        type = "coreclr",
        name = "Launch",
        request = "launch",
        program = find_dll,
    },
    {
        type = "coreclr",
        name = "Attach",
        request = "attach",
        processId = function()
            return require("dap.utils").pick_process()
        end,
    },
}
