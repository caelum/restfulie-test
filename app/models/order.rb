class Order < ActiveRecord::Base
  has_and_belongs_to_many :trainings
  has_many :payments

  state :unpaid, :allow => [:latest, :pay, :cancel]#, :update]
	state :cancelled, :allow => :latest
	state :received, :allow => [:latest, :receive, :check_payment_info]
	state :preparing, :allow => [:latest, :execute_it, :check_payment_info]
	state :ready, :allow => [:latest, :receive, :check_payment_info]
	
	transition :check_payment_info do |order|
	  puts "I am #{order.to_s}"
	   {:controller => :payments, :action => :show, :order_id => order.id, :payment_id => order.payments[0].id, :rel => "check_payment_info"}
	end
	transition :latest, {:action => :show}
	transition :cancel, {:action => :destroy}, :cancelled
	transition :pay, {}, :preparing
	transition :receive, {}, :received
	transition :execute_it, {}, :ready
#	transition :update, {}
	
   def pay(payment)
     move_to :pay
     @payment = payment
     @payment.order = self
   end
  
  def following_transitions
  #   states = []
  #   states << [:execute_it] if @status==:preparing #&& time > 60
  #   #states << [:execute_it, {}, :ready]
  end
  
  def total_price
    total = 0
    @trainings.each do |x|
      total += x.price
    end
    total
  end
  
  def paied?
    payments.size > 0
  end
  
  def can_cancel?
    status=="unpaid"
  end

  def can_pay?
    status=='unpaid'
  end

end
