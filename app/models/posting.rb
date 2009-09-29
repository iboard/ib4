# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
# A Posting has a subject and a body. It belongs to one user and may have many categories as an Categorizable
class Posting < ActiveRecord::Base
  belongs_to  :user
  has_many    :categorizables, :as => :categorizable
  has_many    :categories, :through => :categorizables
end
