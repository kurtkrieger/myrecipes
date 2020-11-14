class IngredientsController < ApplicationController
  
  before_action :set_ingredient, only: [:edit, :show, :update]
  
  before_action :require_admin, except: [:index, :show]
  
  def new
    @ingredient = Ingredient.new
  end
  
  def create
    @ingredient = Ingredient.new(ingredient_params)
    if @ingredient.save
      flash[:success] = "Ingredient was successfully created!"
      redirect_to @ingredient
    else
      render "new"
    end
  end
  
  def show
    @ingredient_recipes = @ingredient.recipes.paginate(page: params[:page], per_page: 2)
  end
  
  def index
    @ingredients = Ingredient.paginate(page: params[:page], per_page: 2)
  end
  
  def edit
  end
  
  def update
    if @ingredient.update(ingredient_params)
      flash[:success] = "Ingredient was updated successfully!"
      redirect_to @ingredient
    else
      render "edit"
    end
  end

  # def destroy
  # end

  private
    def ingredient_params
      params.require(:ingredient).permit(:name)
    end

    def set_ingredient
      @ingredient = Ingredient.find(params[:id])
    end

    def require_admin
      if !logged_in? || (logged_in? && !current_chef.admin?)
        flash[:danger] = "Only administrators can perform that action!"
        redirect_to ingredients_path
      end
    end
end
