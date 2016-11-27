
Token = require "token"
UnionToken = require "union_token"
Card = require "card"

tokens = require "data.tokens"
cards = require "data.cards"
wonders = require "data.wonders"

Game = require "game"
Player = require "player"

math.randomseed os.time!

players = {}
game = with Game!
	for _, card in ipairs cards
		\registerCard card

socket = require "socket"
json = require "json"

requests =
	setname: (request, client) =>
		unless @players[request.player]
			client\send json.encode
				error: "no such player"
			client\sendd "\n"

			return

		@players[request.player].name = request.name or @players[request.player].name

		client\send json.encode
			name: request.name
			player: request.player
		client\send "\n"

	start: (request, client) =>
		if game.finalized
			client\send json.encode
				error: "Game already started!"
			client\send "\n"

			return
		else
			game\finalize!

		client\send "{}"
		client\send "\n"

	"new player": (request, client) =>
		players[client] = with Player!
			if request.name
				.name = request.name

		_, id = @\addPlayer players[client]

		client\send json.encode {
			playerID: id
		}
		client\send "\n"

	tokens: (request, client) =>
		player = @players[request.player]

		client\send json.encode
			list: [token\stringify! for _, token in ipairs player.tokens]
		client\send "\n"

	play: (request, client) =>
		player = @players[request.player]
		card = player.cardsInHand[request.cardIndex]

		print "Playing #{card}/#{request.cardIndex}."
		r, e = pcall -> player\playCard card

		if r
			allEnded = true

			for _, player in ipairs @players
				allEnded and= player.action.type != nil

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

	show: (request, client) =>
		print "Sending public data."
		client\send json.encode {
			turn: game.turn,
			players: [{
				name: player.name,
				played: player.action.type != nil,
				playedCards: [{
					name: card.name
				} for _, card in ipairs player.playedCards]
			} for _, player in ipairs game.players]
		}
		client\send "\n"

	hand: (request, client) =>
		unless request.player
			client\send json.encode "no 'player' field"
			client\send "\n"

			return

		player = game.players[request.player]

		client\send json.encode [card.name for _, card in ipairs player.cardsInHand]
		client\send "\n"

handle = (message, client) ->
	request = json.decode message

	if requests[request.type]
		requests[request.type] game, request, client
	else
		client\send json.encode "the fuck is this '#{request.type}'"
		client\send "\n"

host = "*"
port = 8888

masterSocket = with socket.bind host, port
	\settimeout 0.000001

	print "7w server running on #{host}:#{port}"

clients = {masterSocket}

while 1 do
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
			print "Client lost (#{client}, #{players[client]})."

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

