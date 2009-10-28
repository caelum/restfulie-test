class OrderTrainingConnection < ActiveRecord::Migration
  def self.up
    create_table :orders_trainings, :force => true do |t|
      t.int :training_id
      t.int :order_id
      t.timestamps
    end
  end

  def self.down
    drop_table :orders_trainings
  end
end
