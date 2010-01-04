xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title t('rss.items.title')
    xml.description t('rss.items.description')
    xml.link url_for(:controller => 'home', :only_path => false)
    # Facultative fields
    xml.language I18n.locale.to_s
    xml.lastBuildDate @items[0].created_at.to_s(:rfc822)

    for item in @items
      xml.item do
        xml.guid "item:#{item.id}"
        xml.title item.title_en
        xml.description item.description_en
        xml.category item.category.title
        xml.pubDate item.created_at.to_s(:rfc822)
        xml.link url_for(:controller => 'item', :action => 'index', :ident => item.ident, :only_path => false)
        if item.main_thumb != StaticAsset.default_catalog_icon
          xml.enclosure :url => static_url(item.main_thumb.full_filename), :length => item.main_thumb.filesize, :type => item.main_thumb.mime_type
        end
      end
    end
  end
end
