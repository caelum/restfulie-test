class OrderTrainingConnection < ActiveRecord::Migration
  def self.up
    create_table :orders_trainings, :force => true, :id => false do |t|
      t.integer :training_id
      t.integer :order_id
    end
  end

  def self.down
    drop_table :orders_trainings
  end
end
