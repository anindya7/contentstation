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
      elsif Order.where(product_id: product.id).any?
        flash[:notice] = "Invalid request"
      end
    end
    redirect_to request.referrer
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
    product = Product.find(params[:product_id])
    paypal_options = {
      no_shipping: true, # if you want to disable shipping information
      allow_note: false, # if you want to disable notes
      pay_on_paypal: true # if you don't plan on showing your own confirmation step
    }

    request = Paypal::Express::Request.new(
      :username   => ENV['PAYPAL_USER'],
      :password   => ENV['PAYPAL_PWD'],
      :signature  => ENV['PAYPAL_SIG']
    )
    payment_request = Paypal::Payment::Request.new(
      :currency_code => 'USD',   # if nil, PayPal use USD as default
      :description   => product.name,    # item description
      :quantity      => 1,      # item quantity
      :amount        => product.price,   # item value
    )

    begin
      response = request.setup(
        payment_request,
        paypal_complete_url(product_id: product.id),
        products_url,
        paypal_options  # Optional
      ) 
    rescue Paypal::Exception::APIError => error
      puts error.inspect
      raise error
    end

    redirect_to response.redirect_uri
  end

  def complete_payment
    if params[:PayerID] && params[:product_id] && params[:token]
      order = Order.new
      order.product_id = params[:product_id]
      order.user_id = current_user.id
      order.paypal_customer_token = params[:PayerID];
      order.paypal_payment_token = params[:token];
      order.save_with_paypal_payment
      flash[:notice] = "Order successfully completed"
      redirect_to products_path
    else
      flash[:notice] = "Error occured while making payments through Paypal. Please try again."
      redirect_to products_path
    end
  end

end