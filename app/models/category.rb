class Category < ActiveRecord::Base
  def subcategories
    return Category.find_all_by_parent id
  end
end
