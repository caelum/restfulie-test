class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.string :customer_name

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
