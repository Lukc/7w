
Token = require "token"
UnionToken = require "union_token"
Card = require "card"

-- Base resources
Dilithium = with Token "Dilithium"
	.color = {63, 127, 255}

Metals = with Token "Metals"
	.color = {193, 193, 193}

Supplies = with Token "Supplies"
	.color = {255, 255, 63}

Crew = with Token "Crew"
	.color = {127, 255, 127}

-- Special effect resources
Military = with Token "Military"
	.color = {255, 63, 63}

-- Special resources
Science = with Token "Science"
	.color = {127, 127, 127}

allCards = {
	with Card!
		.name = "Dilithium Mine"
		.type = Card.Resource

		\onTurn Dilithium

		\finalize!

	with Card!
		.name = "Shipyard"
		.type = Card.Military

		\onTurn Military

		\finalize!

	with Card!
		.name = "Starbase"
		.type = Card.Military

		\onTurn Military
		\onTurn Military
		\onTurn Military
		\onTurn Military
		\onTurn Military

		\toBuild Metals
		\toBuild Dilithium
		\toBuild Supplies
		\toBuild Supplies

		\finalize!

	with Card!
		.name = "Science Station"
		.type = Card.Other

		\onTurn Science

		\toBuild Dilithium

		\finalize!

	with Card!
		.name = "Class D World"
		.type = Card.Resource

		\onTurn UnionToken Dilithium, Metals

		\toBuild "Money"

		\finalize!

	with Card!
		.name = "Class M World"
		.type = Card.Resource

		\onTurn UnionToken Crew, Supplies

		\toBuild "Money"

		\finalize!

	with Card!
		.name = "Asteroid"
		.type = Card.Resource

		\onTurn Metals

		\finalize!

	with Card!
		.name = "Flagship"
		.type = Card.Military

		\onTurn Military
		\onTurn Military

		\toBuild "Metals"
		\toBuild "Dilithium"

		\finalize!
}

Game = require "game"
Player = require "player"

game = with Game!
	for _, card in ipairs allCards
		\registerCard card

	\addPlayer with Player!
		.name = "Player A"

	\addPlayer with Player!
		.name = "Player B"

	\addPlayer with Player!
		.name = "Player C"

	\addPlayer with Player!
		.name = "Player D"

	\finalize!

print "Number of cards in game: #{#allCards}"

for _, player in ipairs game.players
	print ":: #{player}"
	with player
		list, stats = .tokens, .tokensPerName

		print "Cards in hand:"
		for _, card in ipairs .cardsInHand
			print "  - " .. tostring card.name
		print

		print "Played cards:"
		for _, card in ipairs .playedCards
			print "  - " .. tostring card.name
		print

		print "Available tokens:"
		for _, token in ipairs list
			print "  - " .. tostring token
		print

		print "Can we play #{allCards[8]}?"
		print "  -> #{\canPlayCard allCards[8]}"
		print

socket = require "socket"
json = require "json"

handle = (message, client) ->
	request = json.decode message

	if request.type == "setname"
		print "Becoming #{request.name}."
		game.players[request.player].name = request.name or game.players[request.player].name

		client\send "{}"
		client\send "\n"
	elseif request.type == "play"
		player = game.players[request.player]
		card = player.cardsInHand[request.cardIndex]

		print "Playing #{card}/#{request.cardIndex}."
		r, e = pcall -> player\playCard card

		if r
			allEnded = true

			for _, player in ipairs game.players
				allEnded and= player.endOfTurn

				unless allEnded
					break

			if allEnded
				game\nextTurn!

			client\send "\"ok\""
		else
			client\send json.encode {
				error: e
			}
		client\send "\n"
	elseif request.type == "show"
		print "Sending public data."
		client\send json.encode {
			turn: game.turn,
			players: [{
				name: player.name,
				playedCards: [{
					name: card.name
				} for _, card in ipairs player.playedCards]
			} for _, player in ipairs game.players]
		}
		client\send "\n"
	elseif request.type == "hand"
		unless request.player
			client\send json.encode "no 'player' field"
			client\send "\n"

			return

		player = game.players[request.player]

		client\send json.encode [{
			name: card.name
		} for _, card in ipairs player.cardsInHand]
		client\send "\n"
	else
		client\send json.encode "the fuck is this '#{request.type}'"
		client\send "\n"

host = "*"
port = 8888

masterSocket = with socket.bind host, port
	\settimeout 0.000001

clients = {masterSocket}

while 1 do
--	client = masterSocket\accept!

--	if client
--		print "New client connected."
--		table.insert clients, client

	removedClients = {}

	for _, client in ipairs socket.select clients, nil, 0.000001
		if client == masterSocket
			newClient = client\accept!

			if newClient
				print "New client connected (#{newClient})."
				table.insert clients, newClient

			continue

		message, failure = client\receive!

		if failure == "closed"
			print "Client lost (#{client})."

			table.insert removedClients, client

			continue

		handle message, client
		print message, failure

	newClients = {}
	for _, client in ipairs clients
		isRemoved = (->
			for i = 1, #removedClients
				if removedClients[i] == client
					return true
		)!

		unless isRemoved
			table.insert newClients, client

	clients = newClients

