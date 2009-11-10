class AddPaymentTime < ActiveRecord::Migration
  def self.up
    add_column :orders, :paid_at, :datetime
  end

  def self.down
    remove_column :orders, :paid_at
  end
end
