
Card = require "card"

class extends Card
	new: =>
		@tokensPerTurn = {}
		@tokensToBuild = {}

		@type = "wonder"

		@finalized = false

	__tostring: =>
		"<Wonder: '#{@name}', #{@tokensPerTurn[1]}, 0 stages built>"

