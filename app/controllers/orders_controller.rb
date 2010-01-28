class OrdersController < ApplicationController
  
  # GET /orders or /orders.xml
  def index
    @orders = Order.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  # GET /orders/1 or /orders/1.xml
  def show
    @order = Order.find(params[:id])
    render_resource @order
  end
  
  
  def add_media_responses(format, resource, options, render_options)
    types = Restfulie::MediaType.default_types
    types = resource.class.media_types if resource.class.respond_to? :media_types
    types.each do |media_type|
      add_media_response(format, resource, media_type, options, render_options)
    end
  end

  def add_media_response(format, resource, media_type, options, render_options)
    controller = self
    format.send media_type.short_name.to_sym do
      media_type.execute_for(controller, resource, options, render_options)
    end
  end

  def thanks
    @order = Order.find(params[:id])
    render :text => "thanks for buying... you bought order ##{@order.id}"
  end
  
  def new
    @order = Order.new
  end

  # POST /orders e /orders.xml
  def create
    respond_to do |format|
      format.html { 
        @order = read_order_from_request 
        if @order.save
          flash[:notice] = 'Order was successfully created.'
          redirect_to(@order)
        else
          render :action => "new"
        end
      }
      format.xml {
        @order = Order.from_xml(request.body.string)
        @order.status = "unpaid"
        if @order.save
          render :text => "", :status => :created, :location => @order
        else
          render :xml => @order.errors, :status => :unprocessable_entity
        end
      }

    end
  end
  
  def read_order_from_request
    @order = Order.new(params[:order])
    @order.status = "unpaid"
    params[:products].each do |p|
      id = p[0]
      @order.trainings << Training.find_by_id(id)
    end
    @order
  end
  
  def pay
    
    @order = Order.find(params[:id])
    
    raise "can not pay" unless @order.can_pay?
    
    post_data = request.body.string
    if post_data.nil? || post_data.empty?
      render :text => """
        You should have passed a payment as:
        <payment>
          <amount>15</amount>
          <cardholder_name>Guilherme Silveira</cardholder_name>
          <card_number>123456789012</card_number>
          <expiry_month>12</expiry_month>
          <expiry_year>12</expiry_year>
        </payment>
        """, :status => 409
        return
    end
    
    payment = Payment.from_xml post_data
    @order.pay(payment)
    payment.save
    saved = @order.save
    
    respond_to do |format|
      format.html { redirect_to(@order) }
      format.xml  { head :ok }
    end
  end

  def receive
    @order = Order.find(params[:id])
    @order.receive
    @order.save
    head :ok
  end
  
  def execute_it
    @order = Order.find(params[:id])
    @order.execute_it
    @order.save
    head :ok
  end

  # DELETE /orders/1
  def destroy
    @order = Order.find(params[:id])
    if !@order.can_cancel?
      head :conflict
    else
      @order.cancel
      @order.save

     head :ok
    end
  end

  
end
