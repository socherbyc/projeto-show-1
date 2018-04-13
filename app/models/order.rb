class Order < ApplicationRecord
  belongs_to :client
  self.primary_key = :number
  has_many :order_details
end
