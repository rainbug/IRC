#!/usr/bin/ruby
require "./IRCBot.rb"

if ARGV.size != 4
  abort "ruby menacing_counter.rb <server> <channel> <count_from> <count_spacing(mins)>"
end

count_from = ARGV[2].to_i
count_spacing = ARGV[3].to_f

bot = IRCBot.new ARGV[0], "menacing_counter"
bot.connect
bot.join ARGV[1]

Thread.new do
  loop { puts bot.readline }
end

loop do 
  if count_from == 0
    exit
  end
  
  bot.message count_from.to_s
  count_from -= 1
  sleep 60 * count_spacing
end


