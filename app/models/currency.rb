class Currency < ActiveRecord::Base
  has_many :orders

  translatable_columns :description, :format
  validates_translation_of :description, :format

  def from_yen(value)
    exact = value.to_f / rate_to_yen
    exact.ceil
  end

  def format_yen_value(value)
    format_value(from_yen(value))
  end

  def format_value(value)
    '%.2f %s' % [value, symbol]
  end

  def self.euro
    Currency.find 2
  end

  def self.dollar
    Currency.find 3
  end
end
