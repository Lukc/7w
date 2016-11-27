
Token = require "token"
UnionToken = require "union_token"

{
	-- Base resources
	Wood: with Token "Wood"
		\finalize!

	Ore: with Token "Ore"
		\finalize!

	Stone: with Token "Stone"
		\finalize!

	Clay: with Token "Clay"
		\finalize!

	-- Refined resources
	Glass: with Token "Glass"
		\finalize!

	Textile: with Token "Textile"
		\finalize!

	Papyrus: with Token "Papyrus"
		\finalize!

	-- Special effect resources
	Military: with Token "Military"
		\finalize!

	Tablet: with Token "Tablet"
		\finalize!

	Gear: with Token "Gear"
		\finalize!

	Compass: with Token "Compass"
		\finalize!

	-- Permanent tokens
	Money: with Token "Money"
		.permanent = true

		\finalize!

	-- Victory \o/
	Victory: with Token "Victory"
		\finalize!
}

