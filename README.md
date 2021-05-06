# Projeto Show 1

It is just a school project.

## scaffold
```
bin/rails generate scaffold client name:string:index password:digest;
bin/rails generate scaffold order number:primary_key client:references;
bin/rails generate scaffold address street city state client:references;
bin/rails generate scaffold product description:text 'price:decimal{10,2}';
bin/rails generate scaffold order_detail amount:integer 'price:decimal{10,2}' order:references product:references;
```

## util
```
bin/rails db:create db:migrate RAILS_ENV=development
bin/rails db:rollback STEP=9999
bundle install # --path vendor/bundle
rails s -e development
```

## gems
- https://github.com/composite-primary-keys/composite_primary_keys

