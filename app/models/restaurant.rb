class Restaurant < ApplicationRecord
  has_many :reviews, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :city, presence: true
  validates :food_type, presence: true
  validates :rating, presence: true, inclusion: { in: [1,2,3,4,5], allow_nil: false}

  mount_uploader :photo, PhotoUploader
  mount_uploader :photo_of_the_chef, PhotoUploader
end
