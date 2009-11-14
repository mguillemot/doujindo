require 'test_helper'

class ShippingPriceTest < ActiveSupport::TestCase
  test "simple ems package" do
    # TODO: write prices fixture
    package = { :type => 'box', :dimensions => [100, 100, 100], :weight => 852 }
    price = ShippingPrice.find_for_package package, 'ems', 'europe'
    assert_equal 2600, price.price
  end
end
