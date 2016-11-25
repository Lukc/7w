
socket = require "socket"
json = require "json"

host = "localhost"
port = 8888

playerID = 1

client = socket.connect host, port

client\settimeout 1

client\send json.encode {
	type: "show"
}
client\send "\n"

answer = json.decode client\receive!

print "#{#answer.players} players"

for _, player in ipairs answer.players
	print player.name

	for _, card in ipairs player.playedCards
		print "    -", card.name

for line in io.stdin\lines!
	arg = [arg for arg in line\gmatch "%S*"]

	local name, cardIndex

	requestType = arg[1]

	if requestType == "setname"
		name = arg[2]
	elseif requestType == "play"
		cardIndex = tonumber arg[2]

	client\send json.encode {
		type: requestType,
		player: playerID,
		name: name,
		cardIndex: cardIndex
	}
	client\send "\n"

	answer = json.decode client\receive!

	if line == "hand"
		for index, card in ipairs answer
			io.stdout\write "  - (#{index}) #{card.name}\n"
	elseif line == "show"
		io.stdout\write (json.encode answer), "\n"

		for _, player in ipairs answer.players
			print "#{player.name} (#{player.played and "waiting" or "playing"})"

			for _, card in ipairs player.playedCards
				print "  - ", card.name
	else
		io.stdout\write (json.encode answer), "\n"

client\close!

