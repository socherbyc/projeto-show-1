# README

## scaffold
bin/rails generate scaffold client name:string:index password:digest is_admin:boolean;
bin/rails generate scaffold order number:primary_key client:references;
bin/rails generate scaffold address street city state client:references;
bin/rails generate scaffold product description:text 'price:decimal{10,2}';
bin/rails generate scaffold order_detail amount:integer 'price:decimal{10,2}' order:references product:references;

## util
bin/rails db:create db:migrate RAILS_ENV=development
bin/rails db:rollback STEP=9999
bundle install # --path vendor/bundle

## gems
https://github.com/composite-primary-keys/composite_primary_keys

## todo
- adicionar `date` no `order`
(4) Solicitar o fechamento do faturamento;
(5) Emissão de pedidos faturados para o cliente;
Emissão dos resumos de faturamento por mês (6), por produto mensal (7) e anual (8).
Consulta em tela (9) e envio de pdf por e-mail (10).


  ```
  class User < ApplicationRecord
    before_save { self.email = email.downcase }
    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
    has_secure_password
  end
  ```

