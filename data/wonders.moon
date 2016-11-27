
Wonder = require "wonder"

tokens = require "data.tokens"

{
	with Wonder!
		.name = "Giza"

		\onTurn tokens.Stone

		\finalize!
}

