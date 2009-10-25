class Category < ActiveRecord::Base
  has_many :items
  has_one :parent, { :class_name => 'Category' }
  belongs_to :parent, { :class_name => 'Category' }

  def subcategories
    return Category.find_all_by_parent_id id
  end

  def all_items
    all = items.clone
    subcategories.each do |subcat|
      all.concat subcat.all_items
    end
    all
  end

  def nav
    p = self
    nav = nil
    if (p)
      nav = [ ];
      while (p)
        nav << [ p.title, :controller => 'category', :action => 'show', :id => p.id ];
        p = p.parent
      end
      nav = nav.reverse
    end
    nav
  end

  def self.root_categories
    Category.find :all, :conditions => ['parent_id is null']
  end
end
