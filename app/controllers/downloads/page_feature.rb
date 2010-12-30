
class Downloads::PageFeature < ParagraphFeature

  feature :downloads_page_downloads, :default_feature => <<-FEATURE
  FEATURE

  def downloads_page_downloads_feature(data)
    webiva_feature(:downloads_page_downloads,data) do |c|
    end
  end
end
