class String
  
  define_method(:to_txt) { 
    textilize(self.to_s.gsub(/(Script|\?php)/i, '*NO SCRIPTING (\1)*'))
    #gsub(/[&><]/) { |special| { ‘>’ => ‘>’, ‘<’ => ‘<’, ‘"’ => ‘"’ }[special] }) } 
  }

end
