class ChefsController < ApplicationController
  
  before_action :set_chef, only: [:edit, :show, :update, :destroy]

  before_action :require_same_user, only: [:edit, :update, :destroy]
  
  before_action :require_admin, only: [:destroy]
  
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
      session[:chef_if] = @chef.id
      cookies.signed[:chef_id] = @chef.id
      flash[:success] = "Welcome #{@chef.chefname} to MyRecipes App!"
      redirect_to @chef
    else
      render "new"
    end
  end
  
  def destroy
    if !@chef.admin?
      chefname = @chef.chefname
      if @chef.destroy
        flash[:danger] = "Chef '#{chefname}' was deleted, along with all associated recipes!"
        redirect_to chefs_path
      else
        render "show"
      end
    end
  end
  
  ############################################################################################
  
  private
    def chef_params
      params.require(:chef).permit(:chefname, :email, :password, :password_confirmation)
    end

    def set_chef
      @chef = Chef.find(params[:id])
    end

    def require_same_user
      if current_chef != @chef && !current_chef.admin
        flash[:danger] = "You can only edit or delete your own account!"
        redirect_to chefs_path
      end
    end
    
    def require_admin
      if logged_in? && !current_chef.admin?
        flash[:danger] = "Only administrators can perform that action!"
        redirect_to root_path
      end
    end
end
