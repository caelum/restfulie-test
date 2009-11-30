class Order < ActiveRecord::Base
  
  acts_as_restfulie do
    transitions = []
    transitions << :execute_it if (self.status == "preparing") && self.paid_one_minute_ago?
    transitions << [:thanks, { :action => :thanks }] if self.status == "received"
    transitions
  end
  
  has_and_belongs_to_many :trainings
  has_many :payments

  state :unpaid, :allow => [:latest, :pay, :cancel]
	state :cancelled, :allow => :latest
	state :received, :allow => [:latest, :check_payment_info]
	state :preparing, :allow => [:latest, :check_payment_info]
	state :ready, :allow => [:latest, :receive, :check_payment_info]# do |order|
#	  order.paid_one_minute_ago?
#	end
	
	transition :check_payment_info do |order|
	   {:controller => :payments, :action => :show, :order_id => order.id, :payment_id => order.payments[0].id, :rel => "check_payment_info"}
	end
	transition :latest, {:action => :show}, {:not_found => 404, :no_change => 304}
	transition :cancel, {:action => :destroy}, :cancelled
	  # 405 ==> (dont do it)
	  # 409 ==> (try again)
	  # order.status=="cancelled".... trying to cancel ==> 405
	  # order.status=="preparing".... trying to update it ==> 409
	  # order.status=="unpaid".... invalid data supplied ==> 400?
	transition :pay, {}, :preparing
	transition :receive, {}, :received
	transition :execute_it, {}, :ready



  def paid_one_minute_ago?
    # takes one minute to be prepared
    self.paid_at < (Time.now - 1.minute)
  end
	
   def pay(payment)
     debugger
     move_to :pay
     self.paid_at = Time.now
     @payment = payment
     @payment.order = self
   end
  
  def total_price
    total = 0
    @trainings.each do |x|
      total += x.price
    end
    total
  end
  
  def paid?
    payments.size > 0
  end
  # 
  # def can_cancel?
  #   status=="unpaid"
  # end
  # 
  # def can_pay?
  #   status=='unpaid'
  # end
  #	transition :update, {}

    # def can_cancel?
    #   raise 405 if @status == :cancelled
    #   # ...
    # end
  
end
