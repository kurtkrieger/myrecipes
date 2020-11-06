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
  end
  
  
  private
    def recipe_params
      params.require(:recipe).permit(:name, :description)
    end

    def set_recipe
      @recipe = Recipe.find(params[:id])
    end
end
