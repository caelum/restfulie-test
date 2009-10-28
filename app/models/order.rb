class Order < ActiveRecord::Base
  has_and_belongs_to_many :trainings
  def following_states
    [
      {:controller => :orders, :action => :destroy},
      {:controller => :orders, :action => :show}
    ]
  end
  
  def total_price
    total = 0
    @trainings.each do |x|
      total += x.price
    end
    total
  end
  
  def can_cancel?
    status!='CANCELLED'
  end
end
