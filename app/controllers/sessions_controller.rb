class SessionsController < ApplicationController
    def new
    end

    def create
        user = User.find_by(username: params[:session][:username].downcase)
        if user && user.authenticate(params[:session][:password])
            session[:user_id] = user.id
            flash[:notice] = "Logged in successfully"
            redirect_to user_path(user)
        else
            flash.now[:alert] = "Credentials incorrent"
            render 'new'
        end
    end

    def delete
        session[:user_id] = nil
        flash[:notice] = "Logged out"
        redirect_to root_path
    end
end