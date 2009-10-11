class String
  
  define_method(:to_txt) { 
    textilize(self.to_s.gsub(/<(Script|\?php)/i, '*NO SCRIPTING (\1)*'))
    #gsub(/[&><]/) { |special| { ‘>’ => ‘>’, ‘<’ => ‘<’, ‘"’ => ‘"’ }[special] }) } 
  }


  define_method(:first_paragraph) { |more_link|
    more_link ||= "..."
    fp = self.to_s.gsub(/(.*)\n.*/,'\1')
    if to_s.length > fp.length
      fp += more_link
    end
    fp
  }
end
