# Project     iboard4
# Author      Andreas Altendorfer
# Copyright   2009 by Andreas Altendorfer
#
# Model for Tags assigned polymorphic to any tagable model
class Tag < ActiveRecord::Base
  
  belongs_to  :tagable, :polymorphic => true
  validates_uniqueness_of :name, :scope => :tagable_id
  before_save :camelize
  
  def tagables
    @tagables = Tag.find_all_by_name(self.name, :order => 'name').map { |tag|
                     eval( "#{tag.tagable_type}.find(#{tag.tagable_id})")
    }
    @tagables.uniq
  end
  
  def self.get_tag_style(tagname)
    if !@tagstyle || (@tagstyle[:timestamp] < Time::now-10.minutes)
      @tagstyle = { :timestamp => Time::now }
      @cnt_max = 0.0
      Tag.ascend_by_name.map(&:name).uniq.each do |n|
        @tagstyle[n] = Tag.name_is(n).count
        @cnt_max = @tagstyle[n] > @cnt_max ? @tagstyle[n] : @cnt_max
      end
    end
    
    size_factor = @tagstyle[tagname].to_f/@cnt_max  # percent
    resize      = (12 * size_factor).round
    size        = 9+resize
    return "font-size: #{size}px;"
  end

  def self.title(t)
    case t.class
    when Posting
      t.subject
    else
      t.title
    end
  end  
  
  private
  def camelize
    self.name        = self.name.camelize unless name.nil?
  end
  
end
