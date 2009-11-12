class Currency < ActiveRecord::Base
  has_many :orders

  translatable_columns :description, :format
  validates_translation_of :description, :format

  def from_yen(value)
    exact = value.to_f / rate_to_yen
    if (exact - exact.floor != 0)
      (exact + 1).floor
    else
      exact.floor
    end
  end

  def format_yen_value(value)
    format_value(from_yen(value))
  end

  def format_value(value)
    "#{value} #{symbol}"
  end
end
