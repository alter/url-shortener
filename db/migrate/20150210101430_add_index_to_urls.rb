class AddIndexToUrls < ActiveRecord::Migration
  def change
    add_index :urls, :short_url, unique: true
    add_index :urls, :full_url, unique: true
  end
end
