#!/usr/bin/ruby
require "./IRCBot.rb"

thistle = IRCBot.new "irc.rizon.net", "thistle"
thistle.connect
thistle.join "#techbuds"

Thread.new do
  loop do
    line = thistle.readline
    puts line

    if line.start_with? "PING"
      thistle.send "PONG :I.am.thistle\r\n"
    end
  
    if line.include? ":_thistle!~" and line.include? "PRIVMSG"
      thistle.message content(line)
    end
  end
end

loop {}
