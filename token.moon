
class
	new: (name) =>
		@name = name
		@color = {127, 127, 127}

	finalize: =>
		@finalized = true

	stringify: =>
		@name

	__tostring: =>
		"<Token: '#{@name}'>"

