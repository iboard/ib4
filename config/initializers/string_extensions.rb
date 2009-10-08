class String
  
  define_method(:to_txt) { 
    textilize(self.to_s.gsub(/[&><]/) { |special| { '>' => '&gt;', '<' => '&lt;', '"' => '&quot;' }[special] })
  }

end
