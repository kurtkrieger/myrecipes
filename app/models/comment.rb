class Comment < ApplicationRecord
  validates :description, presence: true, length: {minimum: 10, maximum: 2000}
  
  validates :chef_id, presence: true
  validates :recipe_id, presence: true
  
  belongs_to :chef
  belongs_to :recipe
  
  default_scope -> { order(updated_at: :desc)}
  
end