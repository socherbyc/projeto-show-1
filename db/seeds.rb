# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)




# clients

Client.create(name: "client-0", password_digest: '123456', is_admin: false)
password_digest = Client.first.password_digest
clients = (1..10).map do |i|
    Client.new(name: "client-#{i}", password_digest: password_digest, is_admin: false)
end
Client.import clients



# products

products = (1..10).map do |i|
    Product.new(description: "description-#{i}", price: (i + i/100.0))
end
Product.import products



clients_ids = Client.select(:id).map(&:id)

# addresses

addresses = clients_ids.map do |client_id|
    Address.new(street: "street-#{client_id}", city: "city-#{client_id}",
        state: "state-#{client_id}", client_id: client_id)
end
Address.import addresses


# orders

orders = clients_ids.map do |client_id|
    (((client_id - 1) * 10)..((client_id - 1) * 10 + 9)).map do |number|
        Order.new(number: number, client_id: client_id, date: DateTime.new(2018, 3, 8))
    end
end
Order.import orders.flatten



orders_numbers = Order.select(:number).map(&:number)
products_ids = Product.select(:id).map(&:id)

# orders details

orders_details = orders_numbers.map do |order_number|
    products_ids.shuffle.slice(0, rand(1..products_ids.length)).map do |product_id|
        OrderDetail.new(amount: rand(1..10), price: rand(1..10), order_number: order_number, product_id: product_id)
    end
end
OrderDetail.import orders_details.flatten

