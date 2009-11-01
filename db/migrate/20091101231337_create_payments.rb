class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.string :card_number
      t.string :cardholder_name
      t.integer :expiry_month
      t.integer :expiry_year

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
