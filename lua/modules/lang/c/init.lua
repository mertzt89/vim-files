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
      initializationOptions =  {
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

  -- Ignore cargo output
  file.add_to_wildignore(".build")
  file.add_to_wildignore("build")

  build.make_builder()
    :with_filetype("c")
    :with_prerequisite_file("wscript")
    :with_build_command("./waf")
    :add()
end

return module


