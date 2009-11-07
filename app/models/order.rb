# 1 - support can_cancel? automatically
# 2 - implement timer for ready
# 3 - allow update

class Order < ActiveRecord::Base
  has_and_belongs_to_many :trainings
  has_many :payments

  state :unpaid, :allow => [:latest, :pay, :cancel]#, :update]
	state :cancelled, :allow => :latest
	state :received, :allow => [:latest, :receive, :check_payment_info]
	state :preparing, :allow => [:latest, :check_payment_info]
	state :ready, :allow => [:latest, :receive, :check_payment_info] # do |order|
	#    [:] if paid_one_minute_ago
	#    []
	#   end
	
	transition :check_payment_info do |order|
	   {:controller => :payments, :action => :show, :order_id => order.id, :payment_id => order.payments[0].id, :rel => "check_payment_info"}
	end
	transition :latest, {:action => :show}
	transition :cancel, {:action => :destroy}, :cancelled
	transition :pay, {}, :preparing
	transition :receive, {}, :received
	transition :execute_it, {}, :ready
#	transition :update, {}

  def paid_one_minute_ago?
    # takes one minute to be prepared
    self.payed_at < (Time.now - 1.minute)
  end
	
   def pay(payment)
     move_to :pay
     self.payed_at = Time.now
     @payment = payment
     @payment.order = self
   end
  
  def following_transitions
     transitions = []
     transitions << :execute_it if (self.status == "preparing") && self.paid_one_minute_ago?
     transitions << [:thanks, { :action => :thanks }] if self.status == "ready"
     transitions
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
