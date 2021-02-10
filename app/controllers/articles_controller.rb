class ArticlesController < ApplicationController
    before_action :find_article, only: [:show, :edit, :update, :destroy]
    before_action :require_user, except: [:show, :index]
    before_action :require_same_user, only: [:edit, :update, :destroy]
    
    def show
    end

    def index
        @articles = Article.all
    end

    def new
        @article = Article.new
    end

    def create
        # render plain: params[:article]
        @article = Article.new(article_params)
        @article.user = current_user
        if @article.save
            flash[:notice] = "Article was created successfully"
            redirect_to article_path(@article)
        else
            render 'new'
        end
    end

    def update
        if @article.update(article_params)
            flash[:notice] = "Article was updated successfully"
            redirect_to @article
        else
            render 'edit'
        end
    end

    def edit
    end

    def destroy
        @article.destroy
        flash[:notice] = "Article deleted successfully"
        redirect_to articles_path
    end

    private
    def find_article
        @article = Article.find(params[:id])
    end

    def article_params
        params.require(:article).permit(:title, :description, category_ids: [])
    end

    def require_same_user
        if current_user != @article.user && current_user.admin?
            flash[:alert] = "User info does not match!"
            redirect_to root_path
        end
    end
end