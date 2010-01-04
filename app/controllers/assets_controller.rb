require 'RMagick'

class AssetsController < ApplicationController
  before_filter :admin_required
  layout 'admin'

  def index
    @assets = StaticAsset.valid_images
  end

  def edit
    @asset = StaticAsset.find params[:id]
    if request.post?
      @asset.title_en = params[:asset][:title_en]
      @asset.title_fr = params[:asset][:title_fr]
      if params[:asset][:asset_file]
        @asset.destroy_thumb
        File.delete File.join(STATIC_ROOT_PATH, @asset.asset_type, @asset.filename)
        update_asset_with_file(@asset, params[:asset][:asset_file])
      end
      @asset.save!
      redirect_to :action => 'index'
    end
  end

  def delete
    @asset = StaticAsset.find params[:id]
    @asset.destroy_thumb
    File.delete File.join(STATIC_ROOT_PATH, @asset.asset_type, @asset.filename)
    @asset.destroy
    add_notice "Image successfully deleted."
    redirect_to :action => 'index'
  end

  def upload
    @asset = StaticAsset.new
    if request.post? and params[:asset] and params[:asset][:asset_file]
      @asset.title_en = params[:asset][:title_en]
      @asset.title_fr = params[:asset][:title_fr]
      if update_asset_with_file(@asset, params[:asset][:asset_file])
        redirect_to :action => 'index'
      end
    end
  end

  protected

  def update_asset_with_file(asset, content)
    logger.info "Starting image upload."
    data = content.read
    server_filename = File.join(STATIC_ROOT_PATH, 'image', content.original_filename)
    if write_file(server_filename, data)
      asset.filename = content.original_filename
      asset.notes = ''
      original_image = Magick::ImageList.new(server_filename)
      icon_file = original_image.resize_to_fit(175, 160)
      if original_image.columns > 1200 or original_image.rows > 1000
        logger.info "Resize image to fit 1200x1000"
        asset.notes += "Automatically resized. "
        original_image.resize_to_fit!(1200, 1000)
      end
      if File.extname(content.original_filename) != '.jpg'
        logger.info "Recompressing original image to JPEG..."
        asset.filename = content.original_filename.gsub(/\.[^\.]+$/, '.jpg')
        asset.notes += "Automatically recompressed to JPEG. "
        original_image.write(File.join(STATIC_ROOT_PATH, 'image', @asset.filename)) { self.quality = 90 }
        logger.info "Recompression done, from #{data.length} to #{original_image.filesize} bytes!"
        File.delete server_filename
        logger.info "Previous file deleted."
      end
      asset.filesize = original_image.filesize
      asset.width = original_image.columns
      asset.height = original_image.rows
      asset.asset_type = 'image'
      asset.mime_type = 'image/jpeg'
      asset.quality = 90

      # Create thumbnail
      icon = StaticAsset.new
      icon.title_en = asset.title_en
      icon.title_fr = asset.title_fr
      icon.asset_type = 'thumb'
      icon.mime_type = 'image/jpeg'
      icon.filename = asset.filename
      icon.notes = "Auto-generated"
      logger.info "Computing thumbnail..."
      icon_filename = File.join(STATIC_ROOT_PATH, 'thumb', icon.filename)
      icon_file.write(icon_filename) { self.quality = 90 }
      icon.filesize = icon_file.filesize
      icon.width = icon_file.columns
      icon.height = icon_file.rows
      icon.quality = 90
      logger.info "Write success into file #{icon_filename} for #{icon.filesize} bytes."

      # Save DB
      StaticAsset.transaction do
        asset.save!
        icon.save!
      end
      logger.info "Upload complete."

      add_notice "File #{asset.filename} uploaded successfully."
      return true
    else
      add_error "Impossible to upload file #{@asset.filename} (file already exists?)"
      return false
    end
  end

  def write_file(name, content)
    if File.exist? name
      return false
    end
    File.open(name, 'wb') do |f|
      logger.info "Writing #{content.length} bytes into file #{name}..."
      f.write(content)
      logger.info "Write success."
    end
    true
  end
end
