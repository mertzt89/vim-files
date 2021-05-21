autocmd = require'lib.autocmd'
autocmd.bind("BufWritePost *.lua", require'packer'.compile())
