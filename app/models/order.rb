class Order < ActiveRecord::Base
  has_and_belongs_to_many :trainings
  has_many :payments

  state :unpaid, :allow => [:latest, :pay, :cancel, :update]
	state [:received, :cancelled], :allow => :latest
	state :preparing, :allow => [:latest]#, :check_payment_info]
	state :ready, :allow => [:latest, :receive]
	
#	transition :check_payment_info, {:controller => :payments, :action => :show, :order_id => id, :payment_id => payments[0].id, :rel => "check_payment_info"}
	transition :latest, {:action => :show}
	transition :cancel, {:action => :destroy}, :cancelled
	transition :pay, {}, :preparing
	transition :receive, {}, :received
	transition :update, {}
  
  # def pay(payment)
  #   self.status = "preparing"
  #   @payment = payment
  #   @payment.order = self
  # end
  
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
