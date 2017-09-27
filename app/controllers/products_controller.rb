class ProductsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:tag].present?
      tag = Tag.find_by_name(params[:tag])
      @free = Exclusivity.find_by_name('Free')
      @products = tag.products.page(params[:page]).per(5) 
    else
      all_products = Product.all
      @free = Exclusivity.find_by_name('Free')
      ordered_products =  current_user.ordered_products
      unavail_products = all_products.select {|prod| (prod.exclusivity_id > @free.id ) && (prod.has_been_ordered?) }
      @products = all_products - ordered_products - unavail_products
      # @products.page(params[:page]).per(5) 
      @products = Kaminari.paginate_array(@products).page(params[:page]).per(5)
    end
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
    if @results.nil?
      @results = Product.by_rating(my_params[:rating] ) if my_params[:rating].present?
    else
      @results = @results.by_rating(my_params[:rating]) if my_params[:rating].present?
    end

    all_products = Product.all
    @free = Exclusivity.find_by_name('Free')
    ordered_products =  current_user.ordered_products
    unavail_products = all_products.select {|prod| (prod.exclusivity_id > @free.id ) && (prod.has_been_ordered?) }
    unless @results.nil?
      @results = @results - ordered_products - unavail_products
      # @results = @results.page(params[:page]).per(5)
      @results = Kaminari.paginate_array(@results).page(params[:page]).per(5)
    end
    render 'index'
  end

  def rate
    product = Product.find(params[:product_id]) if params[:product_id].present?
    unless product.nil?
      if !product.ordered_by_user?(current_user.id)
        redirect_to orders_path
      elsif Rating.where(user_id: current_user.id).where(product_id: product.id).any?
        flash[:notice] = "You have already rated this product"
        redirect_to request.referer
      else
        rating = Rating.new(rating_params)
        rating.user = current_user
        rating.save
        redirect_to request.referer
      end
    end
  end

  def search_params
    params.require(:search).permit(:industry_id, :word_length, :price, :rating, :author, :complexity, :exclusivity)
  end

  def rating_params
    params.permit(:product_id,:rating)
  end

end