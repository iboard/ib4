module Randomizer
  
  RANDOM_CHARACTERS="abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ0123456789-_"
  RANDOM_CHARACTERS_EXTENDED="abcdefghijkmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_$%,;!#*+"
  
  def self.version
    "RANDOMIZER MODULE 1.1.a"
  end
  
  def self.randstr(length=8,urlsafe=true)
    rc = ""
    length.times do 
      if urlsafe
        rc << RANDOM_CHARACTERS[rand(RANDOM_CHARACTERS.length).round]
      else
        rc << RANDOM_CHARACTERS_EXTENDED[rand(RANDOM_CHARACTERS.length).round]        
      end
    end
    rc
  end
  
  
end