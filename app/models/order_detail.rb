class OrderDetail < ApplicationRecord
  self.primary_keys = :order_number, :product_id
  belongs_to :order, foreign_key: :order_number
  belongs_to :product
end
