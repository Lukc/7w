
has = (element, comparator) =>
	comparator or= (a, b) ->
		a == b

	for index, value in ipairs @
		if comparator value, element
			return index

class
	new: =>
		@playedCards = {}
		@cardsInHand = {}

		@action = {}

		@tokens = {}

		@\updateTokens!

	canPlayCard: (card) =>
		availableTokens = @tokens

		for _, token in ipairs card.tokensToBuild
			index = has availableTokens, token

			unless index
				index = has availableTokens, token, (a, b) ->
					for i = 1, #a
						if a[i] == b
							return true

			unless index
				return false, "missing '#{token}' token"

			table.remove availableTokens, index

		true

	playCard: (card) =>
		unless card\playable!
			error "Not a playable Card!"

		@action = {
			type: "play card",
			:card
		}

	nextTurn: =>
		switch @action.type
			when "play card"
				for index, element in ipairs @cardsInHand
					if element == @action.card
						table.remove @cardsInHand, index

						break

				for _, token in ipairs @action.card.tokensOnBuild
					table.insert @tokens, token

				table.insert @playedCards, @action.card
			else
				return nil, "has not played"

		@action = {}

		@\updateTokens!

		true

	updateTokens: =>
		tokens = {}

		for _, token in ipairs @tokens
			print token
			if token.permanent
				table.insert tokens, token

		if @wonder
			for _, token in ipairs @wonder
				table.insert tokens, token

		for _, card in ipairs @playedCards
			for _, token in ipairs card.tokensPerTurn
				table.insert tokens, token

		@tokens = tokens

		tokens

	__tostring: =>
		"<Player: '#{@name}', #{#@playedCards} cards played>"

