class AddPhotoOfTheChefToRestaurants < ActiveRecord::Migration[5.2]
  def change
    add_column :restaurants, :photo_of_the_chef, :string
  end
end
