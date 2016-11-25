
class
	Resource: "resource"
	Military: "military"
	Other: "other"

	new: =>
		@tokensPerTurn = {}
		@tokensToBuild = {}

		@type = @@Other

		@finalized = false

	onTurn: (token) =>
		table.insert @tokensPerTurn, token

	toBuild: (token) =>
		table.insert @tokensToBuild, token

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

