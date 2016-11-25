
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
	local name, cardIndex

	requestType = line\gsub " .*", ""

	if requestType == "setname"
		name = line\gsub "^setname *", ""
		print "name is #{name}"
	elseif requestType == "play"
		index = line\gsub "^play *", ""
		index = tonumber index

		print "playing card n°#{index}"

		cardIndex = index

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
			print player.name

			for _, cardName in ipairs player.playedCards
				print "  - ", cardName
	else
		io.stdout\write (json.encode answer), "\n"

client\close!

