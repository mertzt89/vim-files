local relative = require("util.module").relative
return {
	{ import = relative("early") },
	{ import = relative("code") },
	{ import = relative("editor") },
}
