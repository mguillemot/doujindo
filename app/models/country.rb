class Country < ActiveRecord::Base
  has_many :user_addresses

  translatable_columns :name

  def special?
    id == 256 || id == 229 # Other & Japan
  end

  def self.available_for_shipping
    all = find :all, :conditions => ['paypal_code IS NOT NULL']
    all.sort! { |a, b| a.name <=> b.name }
    all << find(256) # Other...
  end

  def self.from_paypal_code(code)
    res = find_by_paypal_code code
    res || find(256) # Other...
  end
end
