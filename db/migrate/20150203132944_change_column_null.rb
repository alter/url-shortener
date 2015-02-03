class ChangeColumnNull < ActiveRecord::Migration
  def change
    change_column_null :urls, :short_url, false
    change_column_null :urls, :full_url, false
  end
end
