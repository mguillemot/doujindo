require 'RMagick'

class AssetsController < ApplicationController
  before_filter :admin_required

  def index
    @assets = StaticAsset.find_all_by_asset_type 'image'
  end

  def edit
    @asset = StaticAsset.find params[:id]
  end

  def delete
    @asset = StaticAsset.find params[:id]
    if @asset.thumb
      File.delete File.join(STATIC_ROOT_PATH, 'thumb', @asset.thumb.filename)
      @asset.thumb.destroy
    end
    File.delete File.join(STATIC_ROOT_PATH, @asset.asset_type, @asset.filename)
    @asset.destroy
    add_notice "Image successfully deleted."
    redirect_to :action => 'index'
  end

  def upload
    if request.post? and params[:asset]
      logger.info "Starting image upload."

      content = params[:asset][:asset_file]
      data = content.read
      @asset = StaticAsset.new
      @asset.title_en = params[:asset][:title_en]
      @asset.title_fr = params[:asset][:title_fr]
      server_filename = File.join(STATIC_ROOT_PATH, 'image', content.original_filename)
      if write_file(server_filename, data)
        @asset.filename = content.original_filename
        original_image = Magick::ImageList.new(server_filename)
        if File.extname(content.original_filename) != '.jpg'
          logger.info "Recompressing original image to JPEG..."
          @asset.filename = content.original_filename.gsub(/\.[^\.]+$/, '.jpg')
          @asset.notes = "Automatically recompressed to JPEG"
          original_image.write(File.join(STATIC_ROOT_PATH, 'image', @asset.filename)) { self.quality = 90 }
          logger.info "Recompression done, from #{data.length} to #{original_image.filesize} bytes!"
          File.delete server_filename
          logger.info "Previous file deleted."
        end
        @asset.filesize = original_image.filesize
        @asset.width = original_image.columns
        @asset.height = original_image.rows
        @asset.asset_type = 'image'
        @asset.mime_type = 'image/jpeg'
        @asset.quality = 90

        # Create thumbnail
        icon = StaticAsset.new
        icon.title_en = params[:asset][:title_en]
        icon.title_fr = params[:asset][:title_fr]
        icon.asset_type = 'thumb'
        icon.mime_type = 'image/jpeg'
        icon.filename = @asset.filename
        icon.notes = "Auto-generated"
        logger.info "Computing thumbnail..."
        icon_file = original_image.resize_to_fit 175, 160
        icon_filename = File.join(STATIC_ROOT_PATH, 'thumb', icon.filename)
        icon_file.write(icon_filename) { self.quality = 90 }
        icon.filesize = icon_file.filesize
        icon.width = icon_file.columns
        icon.height = icon_file.rows
        icon.quality = 90
        logger.info "Write success into file #{icon_filename} for #{icon.filesize} bytes."

        # Save DB
        StaticAsset.transaction do
          @asset.save!
          icon.save!
        end
        logger.info "Upload complete."

        add_notice "File #{@asset.filename} uploaded successfully."
        redirect_to :action => 'index'
      else
        add_error "Impossible to upload file #{@asset.filename} (file already exists?)"
      end
    else
      @asset = StaticAsset.new
    end
  end

  protected

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
