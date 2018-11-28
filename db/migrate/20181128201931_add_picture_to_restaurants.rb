class AddPictureToRestaurants < ActiveRecord::Migration[5.2]
  def change
    add_column :restaurants, :picture, :string
  end
end
