class AddDraftToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :draft, :boolean, :default => false
  end

  def self.down
    remove_column :pages, :draft
  end
end
