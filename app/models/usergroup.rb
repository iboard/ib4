class Usergroup < ActiveRecord::Base
  belongs_to :user
  has_many   :accessables
  has_many   :group_memberships
  
  JOINABLES = [:public,:friends,:owner]
  
  named_scope :with_join_mask, lambda { |mask| {:conditions => "join_mask & #{mask} > 0 "} }  
  
  
  def joinable_by=(roles)  
    self.join_mask = Usergroup::mask_of(roles) 
    self.join_mask.inspect
  end  

  def joinable_by
    JOINABLES.reject { |r| ((join_mask || 0) & 2**JOINABLES.index(r)).zero? }  
  end
  
  def joinable_symbols  
    joinable_by.map(&:to_sym)  
  end
  
  def self.mask_of(roles)
    roles.reject {|x| x.empty?}.map { |r| 2**JOINABLES.index(r.to_sym) }.sum 
  end
  
  def self.joinable_groups(user)
    with_join_mask(mask_of(['public', 'friends'])).reject { |g|
       !(g.joinable_by.include?(:public) || (g.joinable_by.include?(:friends) && user.my_friends.include?(user)))
    }
  end
  
end


