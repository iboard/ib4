# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
# Simple model which can be attached to any "Categorizable"
class Category < ActiveRecord::Base
  has_many :categorizables
  validates_presence_of :name
  validates_uniqueness_of :name
end
