# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy]
  before_action :select_all_categories, only: %i[new create edit]
  before_action :require_user, except: %i[index show]
  before_action :require_same_user, only: %i[edit update destroy]

  # GET /articles or /articles.json
  def index
    @articles = Article.page(params[:page])
    respond_to do |format|
      format.html
      format.json { render json: @articles, only: %i[id title description] }
    end
  end

  # GET /articles/1 or /articles/1.json
  def show; end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit; end

  # POST /articles or /articles.json
  def create
    @article = Article.new(article_params)
    @article.user = current_user
    respond_to do |format|
      if @article.save
        format.html { redirect_to article_url(@article), notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    @article.user = current_user
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to current_user, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.find(params[:id])
  end

  def select_all_categories
    @categories = Category.all.select(:id, :name)
  end

  # Only allow a list of trusted parameters through.
  def article_params
    params.require(:article).permit(:title, :description, category_ids: [])
  end

  def require_same_user
    return if (current_user == set_article.user) || current_user.admin?

    flash[:alert] = 'Access not allowed to your account!'
    redirect_to set_article
  end
end
