require "./IRCBot.rb"

diagnoser = IRCBot.new "irc.rizon.net", "Mr_Diagnoser"
diagnoser.connect
diagnoser.join "#techbuds"

loop do
  line = diagnoser.readline
  
  diagnoser.message line
  puts line
  sleep 0.5 
end
