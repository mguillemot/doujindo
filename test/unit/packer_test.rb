require 'test_helper'

class PackerTest < ActiveSupport::TestCase
  fixtures :items

  def setup
    @packer = Packer.new
  end

  test "single box item" do
    pcb = items(:pcb)
    res = @packer.find_optimal_packing [ pcb ]
    assert_kind_of Array, res
    assert_equal 1, res.size
    packet = res[0]
    assert_kind_of Hash, packet
    assert_equal 'box', packet[:type]
    assert_kind_of Array, packet[:dimensions]
    assert_equal 3, packet[:dimensions].size
    assert_equal pcb.dimension_width, packet[:dimensions][0]
    assert_equal pcb.dimension_height, packet[:dimensions][1]
    assert_equal pcb.dimension_thickness, packet[:dimensions][2]
    assert_equal pcb.weight, packet[:weight]
  end

  test "two same box items" do
    pcb = items(:pcb)
    res = @packer.find_optimal_packing [ pcb, pcb ]
    assert_kind_of Array, res
    assert_equal 1, res.size
    packet = res[0]
    assert_kind_of Hash, packet
    assert_equal 'box', packet[:type]
    assert_kind_of Array, packet[:dimensions]
    assert_equal 3, packet[:dimensions].size
    assert_equal pcb.dimension_width, packet[:dimensions][0]
    assert_equal pcb.dimension_height, packet[:dimensions][1]
    assert_equal 2 * pcb.dimension_thickness, packet[:dimensions][2]
    assert_equal 2 * pcb.weight, packet[:weight]
  end
  
  test "two different box items" do
    pcb, ufo = items(:pcb), items(:ufo)
    res = @packer.find_optimal_packing [ pcb, ufo ]
    assert_kind_of Array, res
    assert_equal 1, res.size
    packet = res[0]
    assert_kind_of Hash, packet
    assert_equal 'box', packet[:type]
    assert_kind_of Array, packet[:dimensions]
    assert_equal 3, packet[:dimensions].size
    assert_equal ufo.dimension_width, packet[:dimensions][0]
    assert_equal pcb.dimension_height, packet[:dimensions][1]
    assert_equal pcb.dimension_thickness + ufo.dimension_thickness, packet[:dimensions][2]
    assert_equal pcb.weight + ufo.weight, packet[:weight]
  end

  test "different kinds of items" do
    pcb, marisa = items(:pcb), items(:marisa_wall_scroll)
    res = @packer.find_optimal_packing [ marisa, pcb, marisa ]
    assert_kind_of Array, res
    assert_equal 2, res.size
    box = res[0]
    assert_kind_of Hash, box
    assert_equal 'box', box[:type]
    assert_kind_of Array, box[:dimensions]
    assert_equal 3, box[:dimensions].size
    assert_equal pcb.dimension_width, box[:dimensions][0]
    assert_equal pcb.dimension_height, box[:dimensions][1]
    assert_equal pcb.dimension_thickness, box[:dimensions][2]
    assert_equal pcb.weight, box[:weight]
    tube = res[1]
    assert_kind_of Hash, tube
    assert_equal 'tube', tube[:type]
    assert_kind_of Integer, tube[:dimensions]
    assert_equal marisa.dimension_width, tube[:dimensions]
    assert_equal 2 * marisa.weight, tube[:weight]
  end
end
