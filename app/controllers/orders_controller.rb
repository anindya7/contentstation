require 'open-uri'

class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = Order.where(user_id: current_user.id)
  end

  def create
    product = Product.find(params[:product_id])
    if product.present?
      if product.exclusivity == "Free"
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
          data = open(order.product.file_url) 
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

end