
Card = require "card"
UnionToken = require "union_token"

tokens = require "data.tokens"

{
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
}

