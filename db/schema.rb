# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 2010011112043333) do

  create_table "action_contexts", :force => true do |t|
    t.string   "name"
    t.integer  "task_action_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "binaries", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.string   "filename"
    t.string   "mime_type"
    t.integer  "filesize"
    t.integer  "access_mask"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "binaries", ["user_id"], :name => "index_binaries_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "public"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categorizables", :force => true do |t|
    t.integer  "category_id"
    t.integer  "categorizable_id"
    t.string   "categorizable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categorizables", ["categorizable_id", "categorizable_type"], :name => "index_categorizables_on_categorizable_id_and_categorizable_type"
  add_index "categorizables", ["category_id"], :name => "index_categorizables_on_category_id"

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friendships", ["friend_id"], :name => "index_friendships_on_friend_id"
  add_index "friendships", ["user_id"], :name => "index_friendships_on_user_id"

  create_table "group_memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "usergroup_id"
    t.integer  "assigned_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_memberships", ["user_id"], :name => "index_group_memberships_on_user_id"
  add_index "group_memberships", ["usergroup_id"], :name => "index_group_memberships_on_usergroup_id"

  create_table "group_restrictions", :force => true do |t|
    t.string   "restrictable_type"
    t.integer  "restrictable_id"
    t.integer  "usergroup_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_restrictions", ["restrictable_id", "restrictable_type"], :name => "group_restrictions_index_manual"
  add_index "group_restrictions", ["usergroup_id"], :name => "index_group_restrictions_on_usergroup_id"

  create_table "invitations", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.string   "token"
    t.string   "recipient_email"
    t.text     "message"
    t.integer  "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["recipient_id"], :name => "index_invitations_on_recipient_id"
  add_index "invitations", ["sender_id"], :name => "index_invitations_on_sender_id"

  create_table "message_notifications", :force => true do |t|
    t.integer  "message_id"
    t.integer  "user_id"
    t.datetime "read_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "message_notifications", ["message_id"], :name => "index_message_notifications_on_message_id"
  add_index "message_notifications", ["user_id"], :name => "index_message_notifications_on_user_id"

  create_table "messages", :force => true do |t|
    t.integer  "user_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

  create_table "newsletter_blacklists", :force => true do |t|
    t.string   "mail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "newsletter_deliveries", :force => true do |t|
    t.integer  "newsletter_subscription_id"
    t.integer  "newsletter_issue_id"
    t.datetime "delivered_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "failure_messages"
  end

  add_index "newsletter_deliveries", ["newsletter_issue_id"], :name => "index_newsletter_deliveries_on_newsletter_issue_id"
  add_index "newsletter_deliveries", ["newsletter_subscription_id"], :name => "index_newsletter_deliveries_on_newsletter_subscription_id"

  create_table "newsletter_issues", :force => true do |t|
    t.integer  "newsletter_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "queued_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "html_body"
  end

  add_index "newsletter_issues", ["newsletter_id"], :name => "index_newsletter_issues_on_newsletter_id"

  create_table "newsletter_subscriptions", :force => true do |t|
    t.integer  "newsletter_id"
    t.string   "mail"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "newsletter_subscriptions", ["newsletter_id"], :name => "index_newsletter_subscriptions_on_newsletter_id"

  create_table "newsletters", :force => true do |t|
    t.string   "title"
    t.string   "reply_to"
    t.integer  "image_attachment_id"
    t.text     "header"
    t.text     "footer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "banner_file_name"
    t.string   "banner_content_type"
    t.integer  "banner_file_size"
    t.datetime "banner_updated_at"
  end

  create_table "notes", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "user_id"
    t.string   "noteable_type"
    t.integer  "noteable_id"
    t.text     "message"
    t.string   "message_value"
    t.string   "message_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["noteable_id", "noteable_type"], :name => "index_notes_on_noteable_id_and_noteable_type"
  add_index "notes", ["parent_id"], :name => "index_notes_on_parent_id"
  add_index "notes", ["user_id"], :name => "index_notes_on_user_id"

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "body"
    t.boolean  "allow_comments"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "draft",          :default => false
    t.integer  "parent_id"
    t.integer  "position"
  end

  add_index "pages", ["parent_id"], :name => "index_pages_on_parent_id"
  add_index "pages", ["user_id"], :name => "index_pages_on_user_id"

  create_table "permalinks", :force => true do |t|
    t.integer  "linkable_id"
    t.string   "linkable_type"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permalinks", ["linkable_id", "linkable_type"], :name => "index_permalinks_on_linkable_id_and_linkable_type"

  create_table "postings", :force => true do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "draft",                    :default => false
    t.integer  "group_restrictions_count", :default => 0
    t.integer  "comments_count",           :default => 0
  end

  add_index "postings", ["user_id"], :name => "index_postings_on_user_id"

  create_table "project_memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_memberships", ["project_id"], :name => "index_project_memberships_on_project_id"
  add_index "project_memberships", ["user_id"], :name => "index_project_memberships_on_user_id"

  create_table "project_tasks", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "position"
    t.integer  "project_id"
    t.string   "name"
    t.text     "description"
    t.integer  "state_mask"
    t.datetime "date_due"
    t.integer  "flag_mask"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_tasks", ["parent_id"], :name => "index_project_tasks_on_parent_id"
  add_index "project_tasks", ["project_id"], :name => "index_project_tasks_on_project_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.integer  "page_id"
    t.integer  "user_id"
    t.integer  "status"
    t.integer  "access_mask"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_restrictions_count", :default => 0
  end

  add_index "projects", ["page_id"], :name => "index_projects_on_page_id"
  add_index "projects", ["user_id"], :name => "index_projects_on_user_id"

  create_table "tags", :force => true do |t|
    t.integer  "tagable_id"
    t.string   "tagable_type"
    t.string   "name"
    t.string   "color"
    t.string   "background"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["tagable_id", "tagable_type"], :name => "index_tags_on_tagable_id_and_tagable_type"

  create_table "task_actions", :force => true do |t|
    t.integer  "project_task_id"
    t.integer  "user_id"
    t.text     "notice"
    t.integer  "state_flag"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.datetime "date_due"
  end

  create_table "usergroups", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "join_mask"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "usergroups", ["user_id"], :name => "index_usergroups_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "perishable_token",        :default => "",    :null => false
    t.integer  "login_count",             :default => 0,     :null => false
    t.integer  "failed_login_count",      :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_admin",                :default => false, :null => false
    t.string   "fullname"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "invitations_left",        :default => 0
    t.boolean  "send_mail_notifications", :default => true
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"

  create_table "versions", :force => true do |t|
    t.integer  "versioned_id"
    t.string   "versioned_type"
    t.text     "changes"
    t.integer  "number"
    t.datetime "created_at"
  end

  add_index "versions", ["created_at"], :name => "index_versions_on_created_at"
  add_index "versions", ["number"], :name => "index_versions_on_number"
  add_index "versions", ["versioned_type", "versioned_id"], :name => "index_versions_on_versioned_type_and_versioned_id"

end
