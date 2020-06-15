class Floorplan < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_one_attached :original
  has_one_attached :thumb
  has_one_attached :large

  belongs_to :project
end
