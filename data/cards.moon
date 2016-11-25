
Card = require "card"

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
}

