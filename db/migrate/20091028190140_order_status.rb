class OrderStatus < ActiveRecord::Migration
  def self.up
    add_column :orders, :status, :string
    Order.all.each do |o|
      o.status = 'PENDING PAYMENT'
      o.save
    end
  end

  def self.down
    remove_column :orders, :status
  end
end
