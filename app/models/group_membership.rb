class GroupMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :usergroup
end
