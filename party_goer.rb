#!/usr/bin/ruby

require "./IRCBot.rb"
require "./party_goer_reactions.rb"

if ARGV.size != 2
  abort "party_goer.rb <server> <channel>"
end

server = ARGV[0]
channel = ARGV[1]

bot = IRCBot.new server, "party_goer"
bot.connect
bot.join channel 

funny_words = [/hah?\W/i, /funny/i , /lol/i, /rofl/i, /joke/i, /hehe/i]
sips = 0
cups = 0

Thread.new do
  loop do
    line = bot.readline

    if line == ""
      bot.connect
    end
    
    if line.start_with? "PING"
      bot.send "PONG :your.friendly.neighborhood.bot\r\n"
    end

    if line[-3, 1] == "!"
      bot.message chime_in
    else
      funny_words.each do |word|
        if line =~ word and rand(2) < 1
          bot.message laugh
        end
      end
    end
    
    puts line.strip
  end
end

loop do
  sleep(60 * (rand(10) + 3))

  bot.message "ACTION sips from red SOLO cup"
  sips += 1

  if sips == 10
    bot.message "ACTION mumbles something and refills his cup"

    cups += 1
    sips = 0
  end

  if cups == 5
    bot.message "ACTION drops his cup and crumples to the floor"
    sleep(60 * (rand(20) + 11))
    bot.message "ACTION blearily picks up and refills his cup"

    cups = 0
  end
end

