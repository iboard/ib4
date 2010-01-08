module ProjectsHelper
  
  
  def project_index(projects)
    Markaby::Builder.new({}, self) do
      table.standard_table do
        tr do
          th do
            I18n.translate(:name) + "/" +
            I18n.translate(:description) + "/" +
            I18n.translate(:owner)
          end
          th I18n.translate(:project_access_mask)
          th I18n.translate(:state)
        end
        for project in projects
          tr :class => cycle(:odd,:even) do
            td :width => 200 do 
              span :style => 'font-size: 14px; font-weight: bold;' do 
                link_to(h(project.name),project)
              end
              if project && project.id
                div :style => 'margin: 0px; padding: 0px;display: inline;' do 
                  record_links(project, nil, project_path(project).to_s, edit_project_path(project).to_s, project_path(project).to_s).to_s
                end
              end
              div :style => 'margin: 0px; padding:0px; padding-left: 10px;' do
                (project.page_id ? link_to(I18n.translate(:description_page),project.page) : I18n.translate(:project_has_no_description_page)) +
                BR + 
                link_to(h(project.user.fullname),project.user)
              end
            end
            td :align => :center, :width => 100 do  project.access_roles.map(&:to_s).join(', ') end
            td :align => :center, :width => 100 do  project.status_as_string end
          end
        end
        unless projects.any?
          tr do
            td :colspan =>  5 do
              I18n.translate(:no_item_found)
            end
          end
        end
      end
    end
  end

  def project_membership_checkboxes(project)
    Markaby::Builder.new( {}, self) do
      div.membership_checkboxes! do
        ul do
          if project.allowed_users
            project.allowed_users.each do |ms|
              li do
                check_box_tag( "project[project_member_ids][#{ms.id}]", :on, project.members.include?(ms) ) +
                NBSP+
                ms.fullname
              end
            end
          else
            li do I18n.translate(:access_restricted) end
          end
        end
      end
    end
  end  
  
end
