--- C/Cpp module
local file = require("lib.file")

local module = {}

--- Returns plugins required for this module
function module.register_plugins(use) end

local function get_clangd_command()
    local cmd = { "clangd" }
    if vim.env.OECORE_NATIVE_SYSROOT ~= nil then
        table.insert(cmd, "--query-driver=" .. vim.env.OECORE_NATIVE_SYSROOT .. "/**/arm-*")
    end
    return cmd
end

--- Configures vim and plugins for this module
function module.init()
    local lsp = require("modules.lsp")
    local build = require("modules.build")
    local lspconfig = require("lspconfig")

    lsp.register_server(lspconfig.clangd, {
        cmd = get_clangd_command()
    })

    -- Ignore common build output directories
    file.add_to_wildignore(".build")
    file.add_to_wildignore("build")
    file.add_to_wildignore("*.o")

    build.make_builder():with_filetype("c"):with_prerequisite_file("wscript"):with_build_command("./waf"):add()
end

return module
