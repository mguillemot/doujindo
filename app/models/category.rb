class Category < ActiveRecord::Base
  has_many :items
  #has_one :parent, { :class_name => 'Category' }
  #belongs_to :parent, { :class_name => 'Category' }
  acts_as_tree :order => :id

  translatable_columns :title
  validates_translation_of :title

  def subcategories
    return Category.find_all_by_parent_id(self.id)
  end

  def all_items
    all_items_with '1 = 1'
  end

  def visible_items
    all_items_with 'items.show = 1'
  end

  def nav
    p = self
    nav = nil
    if (p)
      nav = [ ];
      while (p)
        nav << [ p.title, { :controller => 'category', :action => 'index', :ident => p.ident } ];
        p = p.parent
      end
      nav = nav.reverse
    end
    nav
  end

  def self.root_categories
    Category.find(:all, :conditions => ['parent_id is null'])
  end

  protected

  def all_items_with(condition)
    all = items.find :all, :conditions => condition
    subcategories.each do |subcat|
      all.concat subcat.all_items_with(condition)
    end
    all
  end

end
