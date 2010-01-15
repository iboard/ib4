module TaskActionsHelper
  
  def task_actions_table(user,actions)
    Markaby::Builder.new({}, self) do
      table.task_actions :class => 'standard_table' do
        tr do
          th I18n.translate( :action )
          th I18n.translate( :date_due )
          th I18n.translate( :project )
          th I18n.translate( :task )
        end
        if actions.any?
          actions.each do |action|
            tr do
              td do 
                link_to(action.context_strings.join(','),user_task_action_path(user,action).to_s)+BR+action.notice
              end
              td do humanize_time_span(action.date_due) end
              td do
                link_to(action.project.name, user_project_path(user,action.project).to_s)
              end
              td do
                link_to action.project_task.name, user_task_action_path(user,action).to_s
              end
            end
          end
        else
          tr do
            th :colspan => 4 do
              I18n.translate( :no_item_found )
            end
          end
        end
      end
    end
  end
end
