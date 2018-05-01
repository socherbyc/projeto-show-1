class CreateClients < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :password_digest

      t.timestamps
    end
    add_index :clients, :name
  end
end
