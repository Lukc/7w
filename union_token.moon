
Token = require "token"

map = (f, array) ->
	[f i for _, i in ipairs array]

class extends Token
	new: (...) =>
		Token.__init @, "Union"

		for _, token in ipairs {...}
			@[#@ + 1] = token

	__tostring: =>
		names = map (=> "'#{@name}'"), @

		"<UnionToken: #{table.concat names, "," }>"

