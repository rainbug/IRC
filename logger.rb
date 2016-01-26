require "./IRCBot.rb"

if ARGV.size != 3 
  abort "./logger.rb <server> <channel> <target>"
end

server =  ARGV[0]
channel = ARGV[1]
target =  ARGV[2]

logger = IRCBot.new server, "lumber-jack"


