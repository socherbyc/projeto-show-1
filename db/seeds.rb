# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


TOTAL_CLIENTS = 10_000
TOTAL_PRODUCTS = 10
TOTAL_ORDERS = TOTAL_CLIENTS * 150
PARTITION_SIZE = 10_000

# TOTAL_CLIENTS = 1_000
# TOTAL_PRODUCTS = 10
# TOTAL_ORDERS = 5_000
# PARTITION_SIZE = 3_000

OrderDetail.delete_all
Order.delete_all
Address.delete_all
Product.delete_all
Client.delete_all

def do_partitioned(total)
    limit = (total.to_f / PARTITION_SIZE).ceil
    (0...limit).each do |partition|
        start = partition * PARTITION_SIZE
        ending = [start + PARTITION_SIZE, total].min
        yield start, ending, partition
    end
end



# clients

Client.create(name: "client-0", password: '123456')
password_digest = Client.first.password_digest
Client.first.destroy!

do_partitioned(TOTAL_CLIENTS) do |start, ending, partition|
    puts "client #{partition}"
    clients = (start...ending).map do |i|
        name = if partition > 0
            "#{Faker::Name.unique.name} #{partition}"
        else
            Faker::Name.unique.name
        end
        Client.new(name: name, password_digest: password_digest)
    end
    Client.import clients
    Faker::Name.unique.clear
end



# products

products_names = [
    "Abacate", "Abóbora", "Abobrinha", "Acelga", "Aipo", "Alcachofra", "Alface",
    "Alfafa", "Almeirão", "Aspargo", "Berinjela", "Bertalha", "Brócolos", "Cebola",
    "Alho", "Cebola-roxa", "Chicória", "Chuchu", "Cogumelo", "Shiitake", "Couve",
    "Couve-de-bruxelas", "Couve-flor", "Couve-galega", "Endívia", "Funcho",
    "Escorcioneira", "Espinafre", "Feijão", "Ervilha", "Lentilha", "Soja", "Vagem",
    "Fruta-pão", "Jiló", "Maxixe", "Milho", "Pepino", "Pimentão", "Jalapeño",
    "Malagueta", "Páprica", "Quiabo", "Batata doce", "Beterraba", "Cenoura",
    "Gengibre", "Mandioca", "Nabo", "Rabanete", "Rábano", "Crem", "Repolho",
    "Rúcula", "Taioba", "Tomate", "Batata", "Jicama", "Mandioquinha", "Taro",
    "Inhame", "Vará", "Pimenta-vermelha", "Feijão-preto", "Azuki",
    "Brotos de feijão", "Fava", "Guandu", "Alho poró"
].shuffle

do_partitioned(TOTAL_PRODUCTS) do |start, ending, partition|
    puts "product #{partition}"
    products = (start...ending).map do |i|
        description = if i < products_names.length
            products_names[i]
        elsif partition > 0
            "#{Faker::Lorem.unique.sentence} #{partition}"
        else
            Faker::Lorem.unique.sentence
        end
        Product.new(description: description, price: (1 + i + (1 + i)/100.0))
    end
    Product.import products
    Faker::Lorem.unique.clear
end



clients_ids = Client.select(:id).map(&:id)

# addresses

do_partitioned(TOTAL_CLIENTS) do |start, ending, partition|
    puts "address #{partition}"
    addresses = clients_ids[start...ending].map do |client_id|
        Address.new(street: Faker::Address.street_name, city: Faker::Address.city,
            state: Faker::Address.state, client_id: client_id)
    end
    Address.import addresses
end



# orders

do_partitioned(TOTAL_ORDERS) do |start, ending, partition|
    puts "order #{partition}"
    orders = (start...ending).map do |i|
        Order.new(number: "#{Faker::Number.unique.number(9)}#{partition}",
            client_id: clients_ids.sample, date: Faker::Time.between(5.year.ago, Date.today))
    end
    Order.import orders
    Faker::Number.unique.clear
end



products_ids = Product.select(:id).map(&:id)

# orders details

do_partitioned(TOTAL_ORDERS) do |start, ending, partition|
    puts "order_detail #{partition}"
    orders_numbers = Order.limit(ending - start).offset(start).map(&:number)
    orders_details = orders_numbers.map do |order_number|
        products_ids.shuffle.slice(0, rand(1..products_ids.length)).map do |product_id|
            OrderDetail.new(amount: Faker::Number.between(1, 100),
                price: Faker::Number.decimal(2, 2), order_number: order_number,
                product_id: product_id)
        end
    end
    begin
        OrderDetail.import orders_details.flatten
    rescue Exception => e
        puts "erro na seeder: #{e}"
    end
end

