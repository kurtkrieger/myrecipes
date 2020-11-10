class ChefsController < ApplicationController
      before_action :set_chef, only: [:edit, :show, :update, :destroy]

  def index
    @chefs = Chef.paginate(page: params[:page], per_page: 2)
  end
  
  def new
    @chef = Chef.new
  end
  
  def show
    @chef_recipes = @chef.recipes.paginate(page: params[:page], per_page: 2)
  end
  
  def edit
  end
  
  def update
    if @chef.update(chef_params)
      flash[:success] = "Chef was updated successfully!"
      redirect_to @chef
    else
      render "edit"
    end
  end
  
  def create
    @chef = Chef.new(chef_params)
    if @chef.save
      flash[:success] = "Welcome #{@chef.chefname.capitalize} to MyRecipes App!"
      redirect_to @chef
    else
      render "new"
    end
  end
  
  def destroy
    if @chef.destroy
      flash[:success] = "Chef was deleted!"
      redirect_to chefs_path
    else
      render "show"
    end
  end
  
  
  private
    def chef_params
      params.require(:chef).permit(:chefname, :email, :password, :password_confirmation)
    end

    def set_chef
      @chef = Chef.find(params[:id])
    end

end
