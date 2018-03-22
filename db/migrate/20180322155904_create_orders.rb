class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    # create_table :orders, id: false do |t|
    # t.integer :number, primary_key: true
    create_table :orders, :primary_key => :number do |t|
      t.references :client, foreign_key: true
      t.datetime :date

      t.timestamps
    end
  end
end
