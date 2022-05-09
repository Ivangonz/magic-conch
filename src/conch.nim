import dimscord, asyncdispatch, options, dimscmd, std/random, std/os, dotenv

load()
randomize()
let TOKEN = os.getEnv("DISCORD_TOKEN")
let discord = newDiscordClient(TOKEN)
var cmd = discord.newHandler()
let responses = [
  "Yes",
  "No",
  "What are you stupid?",
  "I don't know man",
  "Yer",
  "I guess",
]
var response: string
proc onReady(s: Shard, r: Ready) {.event(discord).} =
  echo "Ready as " & $r.user

proc messageCreate (s: Shard, msg: Message) {.event(discord).} =
  response = responses[rand(responses.len - 1)]
  discard await cmd.handleMessage(".", s, msg)

cmd.addChat("concha") do ():
  discard await discord.api.sendMessage(msg.channelId, response)

waitFor discord.startSession()
