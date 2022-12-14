--- Rust module
local file = require("lib.file")

local module = {}

--- Returns plugins required for this module
function module.register_plugins(use) end

--- Configures vim and plugins for this module
function module.init()
    local lsp = require("modules.lsp")
    local build = require("modules.build")
    local lspconfig = require("lspconfig")

    lsp.register_server(lspconfig.rust_analyzer)

    -- Ignore cargo output
    file.add_to_wildignore("target")

    build
        .make_builder()
        :with_filetype("rust")
        :with_prerequisite_file("Cargo.toml")
        :with_build_command("cargo build")
        :with_run_command("cargo run")
        :with_test_command("cargo test")
        :add()
end

return module
