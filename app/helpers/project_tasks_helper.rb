module ProjectTasksHelper
  
  
  def show_project_task_in_project(project_task)
    color = project_task.date_due && project_task.date_due < Time::now ? '#D41E0F' : '#4D4D4D'
    color = '#80AC00' if project_task.state?(:done)
    color = '#dddddd' if project_task.state?(:canceled)
    color = '#aaaaaa' if project_task.state?(:paused)
    color = '#215799' if project_task.state?(:new)
    Markaby::Builder.new({},self) {
        li :id => 'project_task_'+project_task.id.to_s, :class => 'project_task' do
          span :class => 'handle', :style => 'cursor:move;' do
            '['+I18n.translate(:drag).to_s+']'+NBSP
          end
          span do
            link_to_remote( project_task.name,
             :url =>  project_project_task_path(project_task.project.id,project_task.id).to_s,
             :method => :get,
             :with => "project_id='#{project_task.project.id.to_s}'", :id=>"id='#{project_task.id.to_s}'",
             :complete => "Element.highlight('selected_task');"
             )
           end
           span :title => '[new/active/paused/done/canceled/count]',
                :style => 'cursor:help; float:right; margin-left: 10px; margin-right:auto; color:'+color do
             (project_task.date_due ? (humanize_time_span(project_task.date_due)) : "")+
             (project_task.date_due ? NBSP : "")+
             project_task.complete_map.join("/")
           end
           br
         if project_task.children.any?
           ul :id => 'children_sort_list_'+project_task.id.to_s do
             for child in project_task.children
               show_project_task_in_project(child) 
             end
           end
           id_str = 'children_sort_list_'+project_task.id.to_s
           sortable_element(id_str, :url => sort_tasks_project_path(project,:list_id => id_str).to_s, :handle => 'handle' )           
         end
        end
    }.to_s
  end
  
  def show_project_tasks(project,id='project_task_sortlist')
    Markaby::Builder.new({},self) do 
      if project.project_tasks.any?
        ul :id => id do
          for project_task in project.project_tasks.roots
              show_project_task_in_project(project_task)
          end 
        end
        sortable_element(id, :url => sort_tasks_project_path(project,:list_id => id).to_s, :handle => 'handle' )
      else
        ul I18n.translate(:no_item_found)
      end
    end
  end
  
  
  def selected_task_form(project,project_task)
    render( :partial => '/project_tasks/selected_task', :locals => { :project => project, :project_task => project_task }).to_s
  end
  
end
