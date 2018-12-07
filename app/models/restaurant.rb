class Restaurant < ApplicationRecord
  has_many :reviews, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :city, presence: true
  validates :food_type, presence: true
  validates :rating, inclusion: { in: [1,2,3,4,5], allow_nil: false}

  mount_uploader :photo, PhotoUploader
end
