class Payment < ActiveRecord::Base
  belongs_to :order
  acts_as_restfulie
end
