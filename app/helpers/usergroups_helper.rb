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
  
end
