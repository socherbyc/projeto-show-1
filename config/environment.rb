# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

Money.default_currency = Money::Currency.new("BRL")