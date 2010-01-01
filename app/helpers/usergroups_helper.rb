module UsergroupsHelper
  
  def join_group_links(usergroup)
    if current_user.group_memberships.find_by_usergroup_id(usergroup.id)
      l = link_to_remote(
         t(:leave_group), 
         :url => { :controller => 'Users', :action => 'leave_group', :id => current_user,:usergroup_id => usergroup },
         :update => nil,
         :before => "$('join_#{usergroup.id.to_s}_#{current_user.id.to_s}').inner_html='/images/spinner.gif'",
         :complete => "Element.highlight('join_#{usergroup.id.to_s}_#{current_user.id.to_s}');"
      )
    else
      l = link_to_remote(
         t(:join_group), 
         :url => { :controller => 'Users', :action => 'join_group', :id => current_user,:usergroup_id => usergroup },         
         :update => nil,
         :before => "$('join_#{usergroup.id.to_s}_#{current_user.id.to_s}').inner_html='#{image_tag('/images/spinner.gif')}'",
         :complete => "Element.highlight('join_#{usergroup.id.to_s}_#{current_user.id.to_s}');"
      )
    end
    
    content_tag :div, :id => "join_#{usergroup.id.to_s}_#{current_user.id.to_s}", 
    :style=>'border: 1px solid #000; background: #ddd; text-align: center;' do
      l
    end
    
  end
  
  def usergroups_index(usergroups)
    Markaby::Builder.new( {}, self ) do
      table.standard_table :width => '100%', :cellpadding => 0, :cellspacing => 0 do
        tr.table_header do
          th I18n.translate(:name)
          th I18n.translate(:owner)
          th I18n.translate(:join_mask)
          th I18n.translate(:join_leave_group)
          th(:colspan => 3) { I18n.translate(:actions) }
        end
        for usergroup in usergroups do
          tr :class => cycle(:odd,:even) do
            td { 
              strong { link_to CAN_OPEN+NBSP+usergroup.name, usergroup }
            }
            td usergroup.user.fullname
            td usergroup.joinable_by.map{|r| r.to_s.humanize}.join(", ") 
            td {join_group_links( usergroup )}
            if permitted_to?(:edit, usergroup)
              td { link_to( "Edit", edit_usergroup_path(usergroup).to_s ) }
            end
            if  permitted_to?(:destroy, usergroup) 
              td { link_to( "Destroy", usergroup, :confirm => 'Are you sure?', :method => :delete) }
            end
          end
        end
      end
    end    
  end
  
  def list_restricted_items(items)
    Markaby::Builder.new({},self) do
      if items.any?
        ol do
          for item in items
            li { 
              b { link_to(item.restrictable.list_title(40), item.restrictable) }
              small { " " + item.restrictable.class.to_s.humanize }
            }
          end
        end
      else
        ul do
          li I18n.translate(:no_item_found)
        end
      end
    end
  end  

end
