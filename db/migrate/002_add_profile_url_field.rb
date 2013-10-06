class AddProfileUrlField < ActiveRecord::Migration
  def change
    add_column :friends, :profile_url, :string
  end
end
