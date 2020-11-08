class RecipesController < ApplicationController
  
  before_action :set_recipe, only: [:edit, :show, :update, :destroy]

  def index
    @recipes = Recipe.all.order(:name)
  end
  
  def new
    @recipe = Recipe.new
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    if @recipe.update(recipe_params)
      flash[:success] = "Recipe was updated successfully!"
      redirect_to recipe_path(@recipe)
    else
      render "edit"
    end
  end
  
  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.chef = Chef.first
    if @recipe.save
      flash[:success] = "Recipe was created successfully!"
      redirect_to recipe_path(@recipe)
    else
      render "new"
    end
  end
  
  def destroy
    if @recipe.destroy
      flash[:success] = "Recipe was deleted!"
      redirect_to recipes_path
    else
      render "show"
    end
  end
  
  
  private
    def recipe_params
      params.require(:recipe).permit(:name, :description)
    end

    def set_recipe
      @recipe = Recipe.find(params[:id])
    end
end
