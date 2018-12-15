class RemoveAvatarFromRestaurants < ActiveRecord::Migration[5.2]
  def change
    remove_column :restaurants, :avatar, :string
  end
end
