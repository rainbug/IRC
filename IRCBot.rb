require "socket" 

# General purpose IRC bot for handling
# connecting and managing the responses
# of a single server
#
# Some general information:
# This bot sends raw text over a TCP connection to an IRC server
# The default IRC port is always 6667 for unencrypted connections
# Every line in this protocol is delimited with '\r\n'
# When the TCP connection is terminated the server sends EOF, ending the input stream
# All PING requests must be answered with PONGs, or the connection will be terminated
class IRCBot
  
  # Supply third argument only when nick needs to be identified with the NickServ
  # called like bot = IRCBot.new "address", "nick", "password"
  def initialize address, nick, password = 0
    @address = address
    @nick = nick

    if password != 0
      @password = password
    end
  end

  # Establishes connection with server as well as
  # setting the nick, user, and identifying if neccessary
  def connect
    @socket = TCPSocket.open @address, 6667
    @socket.print "USER rainbug 8 * :Real rainbug\r\n"
    @socket.print "NICK #{@nick}\r\n"
    if defined? @password
      self.message "NickServ", "IDENTIFY #{@password}"
    end
  end

  # For use with making listeners
  # This method is very important, and you'll supply it a block
  # which can do whatever you want with the next line read from the server
  def readline 
    @socket.readline
  end

  # Joins the given channel
  def join channel
    @channel = channel
    @socket.print "JOIN #{@channel}\r\n"
  end
  
  # Sends a PRIVMSG to target containing content
  # If two arguments are given, first is the target
  # and second is the content. If one is given
  # the message is sent automatically to the current channel
  def message target = @channel, content
    @socket.print "PRIVMSG #{target} :#{content}\r\n"
  end

  # Sends raw text to the server
  def send text
    @socket.print text
  end
end

def content message
  words = message.split

  # Has no content
  if words.length < 2 
    return ""
  end

  (1..words.size - 1).each do |i|
    if words[i].start_with? ":"
      return words[i..-1].join(" ")[1..-1]
    end
  end

  return ""
end
