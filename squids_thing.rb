require "./IRCBot.rb"

me = IRCBot.new "irc.rizon.net", "SaladDad", "password"
server = "#techbuds"
ops = ["@", "+", "~", "&", "%"]
name1 = ""
names = Hash.new
names["SaladDad"] = 0
iname = 0

me.connect
me.join server

#I want to know what names are stored and what values are stored for them
def listingnames names, name
  if names[name] != nil
    for i in 0..names.length - 1
      puts "Name number " + i.to_s + ": " + names.keys[i].to_s + ": " + names[name].to_s
    end
  end
end

#if someone joins or leaves, adds or removes them from names
def JoinOrLeave phrase, name, names, server
  if phrase.include? "PART " + server
    names[name] = 4
  elsif phrase.include? "JOIN" + server
    names[name] = 0
  end
  
  return names
end

#takes the names from the list of names when SaladDad starts and adds them to names
def listofnames phrase, server, names
  
  if phrase.include? "SaladDad = " + server + " :"
    listnames = phrase[1..-1][phrase[1..-1].index(":")..-1]
    puts "listnames is " + listnames
    numSpaces = 0
    
    #number of spaces between names so it knows how many names there are
    for i in 0..listnames.length - 1
      if listnames[i] == " "
        numSpaces = numSpaces + 1
      end
    end
    
    puts "There are " + numSpaces.to_s + " spaces"
    temp = listnames
    
    
    #isolating the names and putting them in names
    #oh my gosh this code looks so pretty for some reason.
    
    for i in 0..numSpaces
      if i == numSpaces
        tempc = temp[0]
        tempw = temp
      else
        tempw = temp[0..temp.index(" ")]
        tempc = tempw[0]
        temp = temp[temp.index(" ") + 1..-1]
      end
      
      if tempc == "@" or tempc == "~" or tempc == "&" or tempc == ":"
        names[tempw] = 3
      elsif tempc == "%"
        names[tempw] = 2
      elsif tempc == "+"
        names[tempw] = 1
      else
        names[tempw] = 0
      end
    end
    
    return names
  end
  
end

#threaded so I can wait for randomly halfoping and voicing people
#Thread.new do

#This is where everything but the random things is.
loop do
  phrase = me.readline
  puts phrase
  hasName = false
  
  #see if an actual person (or bot in disguise) sent the line
  if phrase.include? "!"
    name = phrase[1..phrase.index("!") - 1]
    
    if name != "py-ctcp" and name != "Global" and name != "peer" and name != "NickServ" and !(name.start_with? "irc.")
      hasName = true
    end
  end
  
  if phrase.start_with? "PING"
    me.send "PONG : what.is.this.i.dont.even"
  end
  
  #response
  #iname increases if he's offered or given a salad so he knows what to say next
  if phrase.include? "SaladDad" and hasName and name != "SaladDad"
    if name != name1
      me.message "Do you want a salad, " + name + "? "
      name1 = name
      iname = 0
    elsif iname == 0
      me.message "Have a salad, " + name + "!"
      iname = iname + 1
    elsif iname == 1
      me.message "\x01ACTION gives " + name + " a salad."
      iname = iname + 1
      if names[name] == 0
        me.message "\x01MODE +v " + name
        names[name] = 1
      end
    else
      me.message "\x01ACTION gives " + name + " another salad."
      if names[name] == 0
        names[name] = 2
        me.message "\x01MODE +h " + name
      elsif names[name] == 1
        names[name] = 2
        me.message "\x01MODE -v " + name
        me.message "\x01MODE +h " + name
      end
    end
  end
  
  names1 = names
  names = listofnames phrase, server, names
  if names1 != names
    listingnames names, name
  end
  
  if names[name] != nil
    names = JoinOrLeave phrase, name, names, server
    listingnames names, name
  end
end
