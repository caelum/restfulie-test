class Order < ActiveRecord::Base
  has_many :training
  def following_states
    [
      {:controller => :posts, :action => :destroy},
      {:controller => :posts, :action => :show}
    ]
  end
end
