# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)





OrderDetail.delete_all
Order.delete_all
Address.delete_all
Product.delete_all
Client.delete_all




# clients

Client.create(name: "client-0", password_digest: '123456', is_admin: false)
password_digest = Client.first.password_digest
clients = (1..100).map do |i|
    Client.new(name: Faker::Name.unique.name, password_digest: password_digest, is_admin: false)
end
Client.import clients



# products

products = (1..10).map do |i|
    Product.new(description: Faker::Lorem.unique.sentence, price: (i + i/100.0))
end
Product.import products



clients_ids = Client.select(:id).map(&:id)

# addresses

addresses = clients_ids.map do |client_id|
    Address.new(street: Faker::Address.street_name, city: Faker::Address.city,
        state: Faker::Address.state, client_id: client_id)
end
Address.import addresses


# orders

orders = clients_ids.map do |client_id|
    (0..3).map do |i|
        Order.new(number: Faker::Number.unique.number(10),
            client_id: client_id, date: Faker::Time.between(5.year.ago, Date.today))
    end
end
Order.import orders.flatten



orders_numbers = Order.select(:number).map(&:number)
products_ids = Product.select(:id).map(&:id)

# orders details

orders_details = orders_numbers.map do |order_number|
    products_ids.shuffle.slice(0, rand(1..products_ids.length)).map do |product_id|
        OrderDetail.new(amount: Faker::Number.between(1, 100),
            price: Faker::Number.decimal(2, 2), order_number: order_number,
            product_id: product_id)
    end
end
OrderDetail.import orders_details.flatten

