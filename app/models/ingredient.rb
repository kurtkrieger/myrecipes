class Ingredient < ApplicationRecord
  validates :name, presence: true, length: {minimum: 2, maximum: 25}, uniqueness: true
  
  default_scope -> { order(name: :asc) }
  
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients
end