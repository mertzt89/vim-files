--- C/Cpp module
local file = require("lib.file")

local module = {}

--- Returns plugins required for this module
function module.register_plugins(use) end

--- Configures vim and plugins for this module
function module.init()
  local lsp = require("modules.lsp")
  local build = require("modules.build")
  local lspconfig = require("lspconfig")

  lsp.register_server(lspconfig.clangd, {
    on_attach = function(client, bufnr)
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function() vim.lsp.buf.format({async = false}) end
      })
    end
  })

  -- Ignore common build output directories
  file.add_to_wildignore(".build")
  file.add_to_wildignore("build")
  file.add_to_wildignore("*.o")

  build.make_builder():with_filetype("c"):with_prerequisite_file("wscript")
    :with_build_command("./waf"):add()
end

return module
