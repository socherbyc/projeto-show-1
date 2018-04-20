class Client < ApplicationRecord
  has_secure_password
  has_one :address, dependent: :destroy
  has_many :orders, dependent: :destroy

  accepts_nested_attributes_for :address
end
