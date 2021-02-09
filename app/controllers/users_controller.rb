class UsersController < ApplicationController
    before_action :find_user, only: [:show, :edit, :update]
    before_action :require_user, only: [:edit, :update]
    before_action :require_same_user, only: [:edit, :update]
    
    def index
        @users = User.all
    end
    
    def show
        @articles = @user.articles
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            session[:user_id] = @user.id
            flash[:notice] = "You have successfully signed up."
            redirect_to root_path
        else
            render 'new'
        end
    end

    def edit
    end

    def update
        if @user.update(user_params)
            flash[:notice] = "User #{@user.username} info was updated successfully"
            redirect_to @user
        else
            render 'edit'
        end
    end

    private
    def find_user
        @user = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(:username, :email, :password)
    end

    def require_same_user
        if current_user != @user
            flash[:alert] = "You can edit only your account"
            redirect_to @user
        end
    end
end
