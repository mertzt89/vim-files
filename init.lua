--
-- init.lua
--
local module = require 'lib.module'

module.add("modules.build")
module.add("modules.core")
module.add("modules.lang.bitbake")
module.add("modules.lang.c")
module.add("modules.lang.lua")
module.add("modules.lang.python")
module.add("modules.lang.rust")
module.add("modules.lang.typescript")
module.add("modules.lsp")
module.add("modules.style")
module.finish_add()
