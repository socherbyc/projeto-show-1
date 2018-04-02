class CreateOrderDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :order_details, {id: false} do |t|
      t.integer :amount
      t.decimal :price, precision: 10, scale: 2
      t.integer :order_number, :limit => 8
      t.references :product, foreign_key: true

      t.timestamps
    end
    execute "ALTER TABLE order_details ADD CONSTRAINT fk_rails__order_number FOREIGN KEY (order_number) REFERENCES orders(number);"
    execute "ALTER TABLE order_details ADD PRIMARY KEY (order_number,product_id);"
  end
end
