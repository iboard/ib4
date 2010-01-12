module ProjectsHelper
  
  def project_index(projects)
    
    Markaby::Builder.new({}, self) do
      table.standard_table do
        tr do
          th do
            I18n.translate(:name)
          end
          th I18n.translate(:description_page)
          th I18n.translate(:state)
        end
        for project in projects
          tr :class => cycle(:odd,:even) do
            td :width => 200 do 
              span :style => 'font-size: 14px; font-weight: bold;' do 
                link_to(CAN_OPEN+NBSP+h(project.name),project)
              end
            end
            td :align => :center, :width => 100 do
              (project.page_id ? link_to(I18n.translate(:description_page),project.page.list_title(50)) : I18n.translate(:project_has_no_description_page))
            end
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
  
  def latest_project_notes
    project = Project.find(params[:project_id])
    Markaby::Builder.new( {}, self ) do
      h1 do 
        I18n.translate(:latest_project_notes)+
        blank+
        link_to(I18n.translate(:view_all), project_notes_path(project).to_s )
      end
      for note in project.notes.find(:all, :order => 'updated_at desc',
        :conditions => ['parent_id is ? and updated_at > ?', nil, Time::now-1.week], :limit => 10)
        p :class => cycle(:odd,:even) do
          span do
            I18n.translate(:user_did_on, 
              :what => I18n.translate("message_type_#{note.message_type}".to_sym),
              :time => humanize_time_span(note.updated_at),
              :user => note.user.fullname
            )
          end
          br
          span :id => 'note_'+note.id.to_s, :style => 'padding-left: 10px' do 
            note.message.to_s + NBSP*3 +
            ( note.user == current_user || is_admin?  ? 
              link_to_remote(I18n.translate(:delete),
                :url => note_path(note, :user_id => note.user_id).to_s,
                :confirm => confirm_delete, 
                :method => :delete
              ) : "" 
             )
          end
        end
      end
      unless project.notes.any?
        p I18n.translate(:no_item_found)
      else
        p do
            link_to(I18n.translate(:view_all), project_notes_path(project).to_s )
        end
      end
    end
  end
  
end
