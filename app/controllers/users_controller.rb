class UsersController < ApplicationController
  
  before_action :set_user, only: [:update, :edit, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:destroy]
  
  
  def index
    @users = User.paginate(page: params[:page], per_page: 3)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to Alpha-blog #{@user.username}"
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end
    
  def edit
    @user = User.find(params[:id])
  end
      
  def update    
    # @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Account was successfully updated!"
      redirect_to articles_path
    else 
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:danger] = "User and all articles created by that user successfully deleted!"
    redirect_to users_path
  end
  
  def show
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 4)
  end
  
  private
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
  
  def set_user
    @user = User.find(params[:id]) 
  end
  
  def require_same_user
    if current_user != @user and !current_user.admin?
    flash[:danger] = "You can edit only yor own account"
    redirect_to root_path
    end
  end
  def require_admin
    if logged_in? and !current_user.admin?        
      flash[:danger] = "Only admin users can perform this action"
      redirect_to root_path
    end
  end

end
