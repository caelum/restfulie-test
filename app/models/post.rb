class Post < ActiveRecord::Base
  def following_states
    [
      {:controller => :posts, :action => :destroy},
      {:controller => :posts, :action => :show}
    ]
  end
end
