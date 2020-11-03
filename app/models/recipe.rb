class Recipe < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates_length_of :name, minimum: 2, maximum: 20
  validates_length_of :description, minimum: 10, maximum: 200
  belongs_to :chef
end