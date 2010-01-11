module ProjectTasksHelper
  
  
  def show_project_task_in_project(project_task)
    color = project_task.date_due && project_task.date_due < Time::now ? '#D41E0F' : '#4D4D4D'
    color = '#80AC00' if project_task.state?(:done)
    color = '#dddddd' if project_task.state?(:canceled)
    color = '#aaaaaa' if project_task.state?(:paused)
    color = '#215799' if project_task.state?(:new)
    Markaby::Builder.new({},self) {
        li :id => 'project_task_'+project_task.id.to_s, :class => 'project_task' do
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
           ul do
             for child in project_task.children
               show_project_task_in_project(child) 
             end
           end
         end
        end
    }.to_s
  end
  
  def show_project_tasks(project)
    Markaby::Builder.new({},self) do 
      if project.project_tasks.any?
        for project_task in project.project_tasks.roots 
          ul do
            show_project_task_in_project(project_task).to_s
          end
        end 
      else
        ul I18n.translate(:no_item_found)
      end  
    end
  end
  
  
  def selected_task_form(project,project_task)
    render( :partial => '/project_tasks/selected_task', :locals => { :project => project, :project_task => project_task }).to_s
  end
  
end
