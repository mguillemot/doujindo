class ShippingPrice < ActiveRecord::Base
  def self.find_for_package(package, method, zone)
    weight = package[:weight]
    find :first, :conditions => ['method = ? AND zone = ? AND ? >= min_weight AND ? <= max_weight', method, zone, weight, weight]
  end
end
