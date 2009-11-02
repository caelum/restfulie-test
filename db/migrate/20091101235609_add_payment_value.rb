class AddPaymentValue < ActiveRecord::Migration
  def self.up
    add_column :payments, :amount, :float
  end

  def self.down
    remove_column :payments, :amount
  end
end
