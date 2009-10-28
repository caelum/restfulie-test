class Post < ActiveRecord::Base
  def following_states
    [
      {:controller => :posts, :action => :destroy},
      {:controller => :posts, :action => :show}
    ]
  end

  
#  def req(uri)
#    req_http(uri).from_xml
#  end
#  order = req('http://localhost/order/1')
#  order.pay


end
