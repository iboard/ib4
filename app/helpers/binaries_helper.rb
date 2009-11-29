module BinariesHelper
  
  
  def access_mask_buttons(binary)
    Binary::ACCESS_ROLES.map { |a|
      if a.to_s == 'private'
        check_box_tag( "binary[access_mask_ids][#{a}]", "1",1, :onclick => "return false;" )+NBSP+t(:yourself)+" (#{t(:always_on)})"
      else
        check_box_tag( "binary[access_mask_ids][#{a}]", "1", binary.accessable_by?(a) )+NBSP+t(a)
      end
    }.join( "<br/>") +
    hidden_field_tag ("binary[access_mask_ids][none]", "")
  end
  
end
