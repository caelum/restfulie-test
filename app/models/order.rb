class Order < ActiveRecord::Base
  has_and_belongs_to_many :trainings
  has_many :payments
  def following_states
    states = [ {:controller => :orders, :action => :show, :rel => "latest" } ]
    states << {:controller => :orders, :action => :destroy} if can_cancel?
    states << {:controller => :orders, :action => :pay} if can_pay?
    states << {:controller => :payments, :action => :show, :order_id => id, :payment_id => payments[0].id, :rel => "check_payment_info"} if paied?
    states
  end
  
  def pay(payment)
    self.status = "preparing"
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
  
  def paied?
    payments.size > 0
  end
  
  def can_cancel?
    status=="payment-expected"
  end

  def can_pay?
    status=='payment-expected'
  end

end
