class RemovePictureFromRestaurants < ActiveRecord::Migration[5.2]
  def change
    remove_column :restaurants, :picture, :string
  end
end
