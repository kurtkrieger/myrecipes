class SessionsController < ApplicationController
  def new
  end
  
  def create
    
    # params[:session][:password]
    chef = Chef.find_by(email: params[:session][:email].downcase)
    if chef
      if chef.authenticate(params[:session][:password])
        session[:chef_id] = chef.id
        flash[:success] = "Authenticated!"
        redirect_to chef
      else
        flash.now[:danger] = "Bad password"
        render "new"
      end
    else
      flash.now[:danger] = "Unknown username"
      render "new"
    end
  end
  
  def destroy
    session[:chef_id] = nil
    flash[:success] = "You have logged out"
    redirect_to root_path
  end

  private
    def session_params
      params.require(:session).permit(:email, :password)
    end
    
end
