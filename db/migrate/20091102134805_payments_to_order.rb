class PaymentsToOrder < ActiveRecord::Migration
  def self.up
    add_column :payments, :order_id, :integer
  end

  def self.down
    remove_column :payments, :order_id
  end
end
