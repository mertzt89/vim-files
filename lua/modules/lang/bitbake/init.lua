--- Bitbake module
local plugman = require("lib.plugman")

local module = {}

--- Returns plugins required for this module
function module.register_plugins() plugman.use({'kergoth/vim-bitbake'}) end

--- Configures vim and plugins for this module
function module.init() end

return module
