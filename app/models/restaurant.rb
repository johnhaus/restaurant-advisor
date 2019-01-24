class Restaurant < ApplicationRecord
  has_many :reviews, dependent: :destroy
  belongs_to :user

  validates :name, presence: true, uniqueness: true
  validates :city, presence: true
  validates :food_type, presence: true
  validates :rating, presence: true, inclusion: { in: [1,2,3,4,5], allow_nil: false}

  geocoded_by :city
  after_validation :geocode, if: :will_save_change_to_city?

  mount_uploader :photo, PhotoUploader
  mount_uploader :photo_of_the_chef, PhotoUploader
end
