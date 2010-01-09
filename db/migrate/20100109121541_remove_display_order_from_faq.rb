class RemoveDisplayOrderFromFaq < ActiveRecord::Migration
  def self.up
    remove_column :faq_entries, :display_order
  end

  def self.down
    raise 'Impossible to roll back this migration'
  end
end
