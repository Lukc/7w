
Card = require "card"
UnionToken = require "union_token"

tokens = require "data.tokens"

cards = with {
	with Card!
		.name = "Lumber Yard"
		.type = Card.Resource

		\onTurn tokens.Wood

		\finalize!

	with Card!
		.name = "Stone Pit"
		.type = Card.Resource

		\onTurn tokens.Stone

		\finalize!

	with Card!
		.name = "Clay Pool"
		.type = Card.Resource

		\onTurn tokens.Clay

		\finalize!

	with Card!
		.name = "Ore Vein"
		.type = Card.Resource

		\onTurn tokens.Ore

		\finalize!

	with Card!
		.name = "Tree Farm"
		.type = Card.Resource

		\onTurn UnionToken tokens.Clay, tokens.Tree

		\finalize!

	with Card!
		.name = "Excavation"
		.type = Card.Resource

		\onTurn UnionToken tokens.Clay, tokens.Stone

		\finalize!

	with Card!
		.name = "Clay Pit"
		.type = Card.Resource

		\onTurn UnionToken tokens.Clay, tokens.Ore

		\finalize!

	with Card!
		.name = "Timber Yard"
		.type = Card.Resource

		\onTurn UnionToken tokens.Stone, tokens.Wood

		\finalize!

	with Card!
		.name = "Forest Cave"
		.type = Card.Resource

		\onTurn UnionToken tokens.Wood, tokens.Ore

		\finalize!

	with Card!
		.name = "Mine"
		.type = Card.Resource

		\onTurn UnionToken tokens.Ore, tokens.Stone

		\finalize!

	with Card!
		.name = "Press"
		.type = Card.Manufacture

		\onTurn tokens.Papyrus

		\finalize!

	with Card!
		.name = "Guard Tower"
		.type = Card.Military

		\onTurn tokens.Military

		\finalize!

	with Card!
		.name = "Baths"
		.type = Card.Civilian

		\onTurn tokens.Victory
		\onTurn tokens.Victory
		\onTurn tokens.Victory

		\toBuild tokens.Stone

		\finalize!

	with Card!
		.name = "Tavern"
		.type = Card.Economic

		\onBuild tokens.Money
		\onBuild tokens.Money
		\onBuild tokens.Money
		\onBuild tokens.Money
		\onBuild tokens.Money

		\finalize!
}
	.getByName = (name) ->
		for _, card in ipairs cards
			if card.name == name
				return card

cards

