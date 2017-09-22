require 'open-uri'

class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @free = Exclusivity.find_by_name('Free')
    @orders = Order.where(user_id: current_user.id)
  end

  def create
    product = Product.find(params[:product_id])
    @free = Exclusivity.find_by_name('Free')
    if product.present?
      if product.exclusivity_id == @free.id
        order = Order.create(user_id: current_user.id, product_id: product.id)
        flash[:notice] = "You have successfully purchased this article - #{order.product.name}"
        redirect_to request.referrer
      elsif Order.where(product_id: product.id).any?
        flash[:notice] = "Invalid request"
        redirect_to request.referrer
      else
        order = Order.create(user_id: current_user.id, product_id: product.id)
        flash[:notice] = "You have successfully purchased this article - #{order.product.name}"
        redirect_to request.referrer
      end
    end
  end

  def download_article
    if params[:order_id].present?
      order = Order.find(params[:order_id])
      unless order.nil?
        if order.user.id == current_user.id
          url = order.product.file_url.sub('http://', '')
          url = url.sub('https://', '')
          data = open("http://#{url}") 
          send_data data.read, filename: "#{order.product.name}.pdf", type: "application/pdf", disposition: 'inline', stream: 'true', buffer_size: '4096'
        else
          flash[:notice] = "Invalid request"
          redirect_to request.referrer   
        end
      else
        flash[:notice] = "Invalid request"
        redirect_to request.referrer
      end
    else
      flash[:notice] = "Invalid request"
      redirect_to request.referrer
    end
  end

  def paypal_checkout
    def paypal_checkout
    # render json: params
    plan = Plan.find(params[:plan_id])
    ppr = PayPal::Recurring.new(
      return_url: new_team_url(plan_id: plan.id),
      cancel_url: teams_url,
      description: plan.name+" Plan - AlphaDeals Annual Subscription.",
      amount: plan.price.to_s+"0",
      currency: "USD"
    )
    response = ppr.checkout
    if response.valid?
      # Create team
      redirect_to response.checkout_url
    else
      raise response.errors.inspect
    end
  end
  end

end