class String
  
  define_method(:to_txt) { 
    textilize(self.to_s.gsub(/<(Script|\?php)/i, '*NO SCRIPTING (\1)*'))
    #gsub(/[&><]/) { |special| { ‘>’ => ‘>’, ‘<’ => ‘<’, ‘"’ => ‘"’ }[special] }) } 
  }

  define_method(:first_paragraph) { |more_link|
    more_link ||= "..."
    fp = self.to_s.gsub(/(.*)\n.*/,'\1')
    if to_s.strip != fp.strip
      fp += more_link
    end
    fp
  }
  
  define_method(:shorten) { |len,rpl|
    len = 4 if len < 4
    if self.length > len+1
      rpl ||= '…'
      s = self[0..(len/2).round] + rpl + self[(self.length-(len/2).round)..self.length-1]
      return s
    end
    return self.to_s
  }

end
