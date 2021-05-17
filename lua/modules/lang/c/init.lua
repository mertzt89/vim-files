--- C/Cpp module

local file = require("lib.file")

local module = {}

--- Returns plugins required for this module
function module.register_plugins()
end

--- Configures vim and plugins for this module
function module.init()
  local lsp = require("modules.lsp")
  local build = require("modules.build")
  local lspconfig = require("lspconfig")

  lsp.register_server(lspconfig.ccls, {
      root_dir = lspconfig.util.root_pattern("compile_commands.json"),
      init_options =  {
        cache = {
          directory = "/tmp/ccls-cache"
        }
      },
      highlight = { lsRanges = true },
      capabilities = {
        textDocument = {
          completion = {
            completionItem = {
              snippetSupport = true
              }
            }
          }
        }
      })

  -- Ignore common build output directories
  file.add_to_wildignore(".build")
  file.add_to_wildignore("build")
  file.add_to_wildignore("*.o")

  build.make_builder()
    :with_filetype("c")
    :with_prerequisite_file("wscript")
    :with_build_command("./waf")
    :add()
end

return module


