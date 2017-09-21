class ProductsController < ApplicationController
  before_action :authenticate_user!

  def index
    all_products = Product.all
    ordered_products =  current_user.ordered_products
    unavail_products = all_products.select {|prod| (prod.exclusivity == "Exclusive") && (prod.has_been_ordered?) }
    @products = all_products - ordered_products - unavail_products
  end

  def search
    my_params = search_params.select {|k,v| v.present?}
    @results = Product.by_industry(my_params[:industry_id]) if my_params[:industry_id].present?
    if @results.nil?
      @results = Product.by_price(my_params[:price] ) if my_params[:price].present?
    else
      @results = @results.by_price(my_params[:price]) if my_params[:price].present?
    end
    if @results.nil?
      @results = Product.by_word_length(my_params[:word_length] ) if my_params[:word_length].present?
    else
      @results = @results.by_word_length(my_params[:word_length]) if my_params[:word_length].present?
    end
    if @results.nil?
      @results = Product.by_author(my_params[:author] ) if my_params[:author].present?
    else
      @results = @results.by_author(my_params[:author]) if my_params[:author].present?
    end
    if @results.nil?
      @results = Product.by_complexity(my_params[:complexity] ) if my_params[:complexity].present?
    else
      @results = @results.by_complexity(my_params[:complexity]) if my_params[:complexity].present?
    end
    if @results.nil?
      @results = Product.by_exclusivity(my_params[:exclusivity] ) if my_params[:exclusivity].present?
    else
      @results = @results.by_exclusivity(my_params[:exclusivity]) if my_params[:exclusivity].present?
    end

    all_products = Product.all
    ordered_products =  current_user.ordered_products
    unavail_products = all_products.select {|prod| (prod.exclusivity == "Exclusive") && (prod.has_been_ordered?) }
    @results = @results - ordered_products - unavail_products

    # render json: @results
    render 'index'
  end

  def search_params
    params.require(:search).permit(:industry_id, :word_length, :price, :rating, :author, :complexity, :exclusivity)
  end

end