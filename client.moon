
socket = require "socket"
json = require "json"

host = "localhost"
port = 8888

playerID = tonumber (arg[1] or "")

client = socket.connect host, port

client\settimeout 1

unless playerID
	client\send json.encode {
		type: "new player"
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
			for index, card in ipairs answer
				io.stdout\write "  - (#{index}) #{card}\n"

	play:
		request: (data, arg) =>
			data.cardIndex = tonumber arg[2]
		handle: (answer) =>
			unless answer.error
				print "Played some card or something."

	show:
		handle: (answer) =>
			io.stdout\write (json.encode answer), "\n"

			for _, player in ipairs answer.players
				print "#{player.name} (#{player.played and "waiting" or "playing"})"

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

