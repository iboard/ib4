# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
# A polymorphic class to attach Categories to any model using
# e.g: Posting 
#   has_many    :categorizables, :as => :categorizable
#   has_many    :categories, :through => :categorizables
class Categorizable < ActiveRecord::Base
  belongs_to  :category
  belongs_to  :categorizable, :polymorphic => true
end
