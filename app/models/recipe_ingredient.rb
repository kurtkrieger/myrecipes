class RecipeIngredient < ApplicationRecord
  validates :recipe_id, presence: true
  validates :ingredient_id, presence: true
  

  belongs_to :recipe
  belongs_to :ingredient
end