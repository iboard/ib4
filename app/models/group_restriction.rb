class GroupRestriction < ActiveRecord::Base
  
  belongs_to  :usergroup
  belongs_to  :restrictable, :polymorphic => true
  

end
