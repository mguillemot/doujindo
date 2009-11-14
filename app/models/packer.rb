class Packer
  def find_optimal_packing(items)
    result = [ ]
    box = find_box_packing items.select { |i| i.package_type == 'box' }
    result << box if box
    tube = find_tube_packing items.select { |i| i.package_type == 'tube' }
    result << tube if tube
    result
  end

  private

  def find_box_packing(items)
    return nil if items.empty?
    weight = 0
    height = 0
    base_dimensions = [0, 0]
    items.each do |item|
      dim = dimensions(item)
      base_dimensions[0] = [base_dimensions[0], dim[2]].max
      base_dimensions[1] = [base_dimensions[1], dim[1]].max
      height += dim[0]
      weight += item.weight
    end
    { :type => 'box', :dimensions => [base_dimensions[0], base_dimensions[1], height], :weight => weight }
  end

  def find_tube_packing(items)
    return nil if items.empty?
    weight = 0
    width = 0
    items.each do |item|
      width = [width, item.dimension_width].max
      weight += item.weight
    end
    { :type => 'tube', :dimensions => width, :weight => weight }
  end

  def dimensions(item)
    [item.dimension_width, item.dimension_height, item.dimension_thickness].sort
  end
end