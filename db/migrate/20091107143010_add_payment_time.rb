class AddPaymentTime < ActiveRecord::Migration
  def self.up
    add_column :orders, :payed_at, :datetime
  end

  def self.down
    remove_column :orders, :payed_at
  end
end
