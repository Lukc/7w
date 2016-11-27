
socket = require "socket"
json = require "json"

cards = require "data.cards"

host = "localhost"
port = 8888

playerID = tonumber (arg[1] or "")

client = socket.connect host, port

client\settimeout 1

unless playerID
	client\send json.encode {
		type: "new player",
		name: os.getenv "USER"
	}
	client\send "\n"

	answer = json.decode client\receive!

	playerID = answer.playerID

print "Connected as player #{playerID}."

requests =
	setname:
		request: (data, arg) =>
			data.name = arg[2]
		handle: (answer) =>
			print "Name changed to #{answer.name}."

	start:
		handle: (answer) =>
			unless answer.error
				print "Game started."

	hand:
		handle: (answer) =>
			for index, cardName in ipairs answer
				card = cards.getByName cardName

				io.stdout\write "\027[00;01m"
				io.stdout\write "  - (#{index}) #{cardName}\n"

				-- Printing card color.
				switch card.type
					when "other"
						io.stdout\write "\027[01;30m"
					when "military"
						io.stdout\write "\027[01;31m"
					when "scientific"
						io.stdout\write "\027[01;32m"
					when "economic"
						io.stdout\write "\027[01;33m"
					when "civilian"
						io.stdout\write "\027[01;34m"
					when "guild"
						io.stdout\write "\027[01;34m"
					when "resource"
						io.stdout\write "\027[01;36m"
					when "manufacture"
						io.stdout\write "\027[00;37m"
					else
						io.stdout\write "\027[00;01m"

				tokens = card.tokensPerTurn
				tokenStrings = [token\stringify! for _, token in ipairs tokens]

				print "    produces: " .. table.concat tokenStrings, ", "

				if #card.tokensToBuild > 0
					tokens = card.tokensToBuild
					tokenStrings = [token\stringify! for _, token in ipairs tokens]

					print "    cost:     " .. table.concat tokenStrings, ", "

				-- Color removal.
				io.stdout\write "\027[00m"

	tokens:
		handle: (answer) =>
			for _, token in ipairs answer.list
				print token

	play:
		request: (data, arg) =>
			data.cardIndex = tonumber arg[2]
		handle: (answer) =>
			unless answer.error
				print "Played some card or something."

	show:
		handle: (answer) =>
			io.stdout\write (json.encode answer), "\n"

			for id, player in ipairs answer.players
				print "#{player.name} [#{id}] (#{player.played and "waiting" or "playing"})"

				for _, card in ipairs player.playedCards
					print "  - ", card.name

for line in io.stdin\lines!
	arg = [arg for arg in line\gmatch "%S*"]

	request = requests[arg[1]]

	data =
		type: arg[1]
		player: playerID

	if request and request.request
		request.request {}, data, arg

	print ">> " .. json.encode data
	client\send json.encode data
	client\send "\n"

	answer = json.decode client\receive!
	print "<< " .. json.encode answer

	if request and request.handle
		request.handle {}, answer
	else
		io.stdout\write (json.encode answer), "\n"

client\close!

