class Recipe < ApplicationRecord
  validates :name,        presence: true, length: {minimum: 5, maximum: 100}
  
  validates :description, presence: true, length: {minimum: 10, maximum: 2000}
  
  validates :chef_id,     presence: true
  
  default_scope -> { order(updated_at: :desc) }
  
  belongs_to :chef
end