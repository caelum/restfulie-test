class OrdersController < ApplicationController
  
#  before_filter :resource_preload , :only => :destroy
  
  def resource_preload
    loaded_value = 
    self.instance_variable_set :name_plurarized, loaded_value
    @order = Order.find(params[:id])
    
  end
  
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
    @order.updated_at = Time.now
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render_resource @order, :except => [:paid_at] }
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
  end
  
  def http_date_from(value)
    return nil if value.nil?
    return nil if value.invalid?
    value
  end
  
  # http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html
  # if the date is invalid or not given, goes on
  # if the date is given and it has been modified AND the return code would be 2** or 412, return 412
  # if the result was going to be 304 (due to If-None-Match, If-Modified-Since, it will give 412: unspecified in the http server
  def check_resource_modification_state(resource)
    date = http_date_from(request['If-Unmodified-Since'])
    if date.nil? && Time.now.after(date)
      head :code => 412
    end
  end

  def pay
    
    @order = Order.find(params[:id])
    
    #check_resource_modification_state(@order)
    
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
