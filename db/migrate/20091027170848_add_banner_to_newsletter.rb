class AddBannerToNewsletter < ActiveRecord::Migration
  def self.up
    add_column :newsletters, :banner_file_name,    :string
    add_column :newsletters, :banner_content_type, :string
    add_column :newsletters, :banner_file_size,    :integer
    add_column :newsletters, :banner_updated_at,   :datetime
  end

  def self.down
    remove_column :newsletters, :banner_file_name
    remove_column :newsletters, :banner_content_type
    remove_column :newsletters, :banner_file_size
    remove_column :newsletters, :banner_updated_at
  end
end
