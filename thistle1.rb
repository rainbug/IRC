require "./IRCbot.rb"

thistle = IRCBot.new "irc.rizon.net", "thistle"
thistle.connect
thistle.join "#techbuds"

Thread.new do
  loop do
    line = thistle.readline
  
    if line.include? ":_thistle!~" and line.include? "PRIVMSG"
      
    end
  end
end
