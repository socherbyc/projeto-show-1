class Order < ApplicationRecord
  belongs_to :client

  # set_primary_key :number
end
