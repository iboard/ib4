class Permalink < ActiveRecord::Base
  belongs_to  :linkable, :polymorphic => true
  validates_uniqueness_of :url
  validates_presence_of   :url
end
