class CategoriesController < ApplicationController
    before_action :require_admin, except: [:index, :show]

    def new
        @category = Category.new
    end

    def index 
        @categories = Category.all
    end
    
    def show 
        @category = Category.find(params[:id])
        @articles = @category.articles
    end

    def create
        @category = Category.new(category_params)
        if @category.save
            flash[:notice] = "Category was created successfully"
            redirect_to @category
        else
            render 'new'
        end
    end

    def edit
        @category = Category.find(params[:id])
    end

    def update
        @category = Category.find(params[:id])
        if @category.update(category_params)
            flash[:notice] = "Category updated successfully"
        end
        redirect_to category_path(@category)
    end

    private

    def category_params
        params.require(:category).permit(:name)
    end

    def require_admin
        if !(logged_in? && current_user.admin?)
            flash[:alert] = "You are not authorized to do that"
            redirect_to categories_url
        end
    end
end