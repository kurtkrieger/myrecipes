class RecipesController < ApplicationController
  
  before_action :set_recipe, only: [:edit, :show, :update, :destroy]
  
  before_action :require_user, except: [:index, :show]

  before_action :require_same_user, only: [:edit, :update, :destroy]
  
  def index
    @recipes = Recipe.paginate(page: params[:page], per_page: 2)
    
    respond_to do |format|
      format.html
      format.csv { send_data @recipes.to_csv }
    end
  end
  
  def new
    @recipe = Recipe.new
  end
  
  def show
    @comment = Comment.new
    @comments = @recipe.comments.paginate(page: params[:page], per_page: 2)
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
    
    @recipe.chef = current_chef
    
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
  
  ############################################################################################
  
  private
    def recipe_params
      params.require(:recipe).permit(:name, :description, ingredient_ids: [])
    end

    def set_recipe
      @recipe = Recipe.find(params[:id])
    end
    
    def require_same_user
      if current_chef != @recipe.chef && !current_chef.admin?
        flash[:danger] = "You can only edit or delete your own recipes!"
        redirect_to recipes_path
      end
    end
end
