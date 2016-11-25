
class
	new: (name) =>
		@name = name
		@color = {127, 127, 127}

	__tostring: =>
		"<Token: '#{@name}'>"

