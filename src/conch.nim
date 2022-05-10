import dimscord, asyncdispatch, options, dimscmd, std/random, std/os, dotenv, json

load()
randomize()
let TOKEN = os.getEnv("DISCORD_TOKEN")

let discord = newDiscordClient(TOKEN)
var cmd = discord.newHandler()

let responses = parseFile("src/data/responses.json")
let fortunes = parseFile("src/data/fortunes.json")
let tarotCards = parseFile("src/data/tarot.json")

var response: string
var fortune: string
proc onReady(s: Shard, r: Ready) {.event(discord).} =
  echo "Ready as " & $r.user

proc messageCreate (s: Shard, msg: Message) {.event(discord).} =
  discard await cmd.handleMessage(".", s, msg)

cmd.addChat("concha fortune") do ():
  fortune = fortunes[rand(fortunes.len - 1 )].getStr()
  discard await discord.api.sendMessage(msg.channelId, fortune)

cmd.addChat("concha question") do ():
  response = responses[rand(responses.len - 1)].getStr()
  discard await discord.api.sendMessage(msg.channelId, response)

waitFor discord.startSession()
