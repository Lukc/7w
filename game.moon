
class
	new: =>
		@players = {}
		@turn = 1

		@registeredCards = {}

	registerCard: (card) =>
		table.insert @registeredCards, card

	addPlayer: (player) =>
		for _, oldPlayer in ipairs @players
			if player == oldPlayer
				error "Added a player twice in the same game."

		table.insert @players, player

	nextTurn: =>
		for _, player in ipairs @players
			player\nextTurn!

		@turn += 1

	finalize: =>
		allCards = [card for _, card in ipairs @registeredCards]

		for i = 1, #allCards
			j = math.random 1, #allCards
			allCards[i], allCards[j] = allCards[j], allCards[i]

		for playerId, player in ipairs @players
			for i = 1, #allCards / #@players
				table.insert player.cardsInHand,
					allCards[math.floor i + (#allCards/#@players) * (playerId - 1)]

