class RenameStaticAssetFormat < ActiveRecord::Migration
  def self.up
    rename_column :static_assets, :format, :mime_type
  end

  def self.down
    raise 'Impossible to roll back this migration'
  end
end
