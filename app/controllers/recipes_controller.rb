class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all.order(:name)
  end
end
