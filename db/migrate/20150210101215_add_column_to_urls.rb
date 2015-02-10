class AddColumnToUrls < ActiveRecord::Migration
  def change
    add_column :urls, :redirected, :integer, :default => 0
  end
end
