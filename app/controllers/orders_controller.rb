class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.xml
  def index
    @orders = Order.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.xml
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order.to_xml(:controller=>self) }
    end
  end
  
  def new
    @order = Order.new
  end

  # POST /orders
  # POST /orders.xml
  def create
    @order = Order.new(params[:order])
    @order.status = "payment-expected"
    params[:products].each do |p|
      id = p[0]
      @order.trainings << Training.find_by_id(id)
    end

    respond_to do |format|
      if @order.save
        flash[:notice] = 'Order was successfully created.'
        format.html { redirect_to(@order) }
        format.xml  { render :xml => @order, :status => :created, :location => @order }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def pay
    @order = Order.find(params[:id])
    raise :can_not_pay if !@order.can_pay?

    puts "Reading from #{params[:payment]}"
    payment = Payment.from_xml params[:payment]
    puts "Paymento to put #{payment}"
    
    # @order.pay(payment)
    @order.save
    
    respond_to do |format|
      format.html { redirect_to(@order) }
      format.xml  { head :ok }
    end
  end

  # payment example  
  # <payment>
  #   <amount>15</amount>
  #   <cardholder_name>Guilherme Silveira</cardholder_name>
  #   <card_number>123456789012</card_number>
  #   <expiry_month>12</expiry_month>
  #   <expiry_year>12</expiry_year>
  # </payment>

  # DELETE /orders/1
  def destroy
    @order = Order.find(params[:id])
    raise :can_not_cancel if !order.can_cancel?
    @order.status = 'cancelled'
    @order.save

    respond_to do |format|
      format.html { redirect_to(@order) }
      format.xml  { head :ok }
    end
  end

  
end
