
class Downloads::PageFeature < ParagraphFeature

  feature :downloads_page_downloads, :default_feature => <<-FEATURE
  <cms:downloads>
    <ul>
    <cms:download>
    <li><cms:download_link><cms:name/></cms:download_link></li>
    </cms:download>
    </ul>
  </cms:downloads>
  FEATURE

  def downloads_page_downloads_feature(data)
    webiva_feature(:downloads_page_downloads,data) do |c|
      c.loop_tag('download') do |t| 
        if t.attr['category']
          data[:downloads].select { |d| d.category == t.attr['category'] }
        else
          data[:downloads] 
        end
      end
      c.h_tag('download:name') { |t| t.locals.download.name }
      c.h_tag('download:description') { |t| t.locals.download.description }
      c.link_tag('download:download') { |t| site_node.link t.locals.download.id.to_s }
    end
  end
end
