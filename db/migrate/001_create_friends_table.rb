class CreateFriendsTable < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.string :uid
      t.string :name
      t.string :pic
      t.string :address
      t.float :latitude
      t.float :longitude
      t.boolean :gmaps
      t.timestamps
    end
  end
end
