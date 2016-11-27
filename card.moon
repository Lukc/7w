
class
	Resource: "resource"
	Military: "military"
	Manufacture: "manufacture"
	Science: "science"
	Civilian: "civilian"
	Economic: "economic"
	Other: "other"

	new: =>
		@tokensPerTurn = {}
		@tokensToBuild = {}

		-- For permanent tokens.
		@tokensOnBuild = {}

		@type = @@Other

		@finalized = false

	onTurn: (token) =>
		table.insert @tokensPerTurn, token

	toBuild: (token) =>
		table.insert @tokensToBuild, token

	onBuild: (token) =>
		unless token.permanent
			error "Trying pass non-permanent token to Card.onBuild"

		table.insert @tokensOnBuild, token

	finalize: =>
		unless @name
			error "Card was finalized without name"

		unless @type
			error "Card was finalized without type"

		@finalized = true

	playable: =>
		@finalized == true

	__tostring: =>
		"<Card: '#{@name}', #{@type}, #{#@tokensPerTurn} tokens>"

