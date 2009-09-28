module Randomizer
  
  RANDOM_CHARACTERS="abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ0123456789.,:;"
  
  def self.version
    "RANDOMIZER MODULE 1.0"
  end
  
  def self.randstr(length=8)
    rc = ""
    length.times do 
      rc << RANDOM_CHARACTERS[rand(RANDOM_CHARACTERS.length).round]
    end
    rc
  end
  
  
end