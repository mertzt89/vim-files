--- Bitbake module
local plug = require("lib.plug")

local module = {}

--- Returns plugins required for this module
function module.register_plugins(use)
    use({ "kergoth/vim-bitbake" })
end

--- Configures vim and plugins for this module
function module.init() end

return module
