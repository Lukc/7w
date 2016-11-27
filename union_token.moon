
Token = require "token"

map = (f, array) ->
	[f i for _, i in ipairs array]

class extends Token
	new: (...) =>
		Token.__init @, "Union"

		for _, token in ipairs {...}
			@[#@ + 1] = token

	stringify: =>
		table.concat [token.name for _, token in ipairs @], "/"

	__tostring: =>
		names = map (=> "'#{@name}'"), @

		"<UnionToken: #{table.concat names, "," }>"

