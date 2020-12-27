--- Build module

local plugman = require("lib.plugman")
local autocmd = require("lib.autocmd")
local file = require("lib.file")

local module = {}

--- Returns plugins required for this module
function module.register_plugins()
  plugman.use({"tpope/vim-dispatch", config = function() 
    local keybind = require("lib.keybind")

    -- Don't create default key bindings
    vim.g.dispatch_no_maps = 1
    keybind.bind_command(keybind.mode.NORMAL, "<leader>pc", ":Dispatch<CR>", { noremap = true }, "Compile")
    keybind.bind_function(
        keybind.mode.NORMAL,
        "<leader>pr",
        function()
        local run_cmd = vim.b.c_dispatch_run
        if run_cmd ~= nil then
            vim.cmd("Dispatch " .. run_cmd)
        else
            print("No run command configured! (Buffer variable 'c_dispatch_run' missng)")
        end
        end,
        { noremap = true },
        "Run"
    )
    keybind.bind_function(
        keybind.mode.NORMAL,
        "<leader>pt",
        function()
        local test_cmd = vim.b.c_dispatch_test
        if test_cmd ~= nil then
            vim.cmd("Dispatch " .. test_cmd)
        else
            print("No test command configured! (Buffer variable 'c_dispatch_test' missng)")
        end
        end,
        { noremap = true },
        "Test"
    )

  end})
end

function module.init()

end

local Builder = {
  with_filetype = function(self, filetype)
    table.insert(self.filetypes, filetype)
    return self
  end,

  with_build_command = function(self, command)
    self.build_command = command
    return self
  end,

  with_run_command = function(self, command)
    self.run_command = command
    return self
  end,

  with_test_command = function(self, command)
    self.test_command = command
    return self
  end,

  with_prerequisite_file = function(self, file)
    table.insert(self.prerequisite_files, file)
    return self
  end,

  add = function(self)
    assert(self.build_command ~= nil)
    assert(#self.filetypes > 0)

    autocmd.bind_filetype(self.filetypes, function()
      -- Check prereq files exist
      for _, f in pairs(self.prerequisite_files) do
        if not file.is_readable(f) then return end
      end

      -- Set the build command
      -- "b:dispatch" used by vim-dispatch
      vim.api.nvim_buf_set_var(0, "dispatch", self.build_command)

      if self.test_command ~= nil then
        -- Set the test command
        -- "b:c_dispatch_test" used in config, not a vim-dispatch thing
        vim.api.nvim_buf_set_var(0, "c_dispatch_test", self.test_command)
      end

      if self.run_command ~= nil then
        vim.api.nvim_buf_set_var(0, "c_dispatch_run", self.run_command)
      end
    end)
  end,
}

function module.make_builder()
  local builder = {
    filetypes = {},
    build_command = nil,
    run_command = nil,
    prerequisite_files = {},
  }
  setmetatable(builder, { __index = Builder })

  return builder
end

return module

