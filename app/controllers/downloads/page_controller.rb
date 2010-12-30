
class Downloads::PageController < ParagraphController

  editor_header 'Downloads Paragraphs'

  editor_for :downloads, :name => "Downloads", :feature => :downloads_page_downloads, :no_options => true,
                         :inputs => [[:id, 'Download Item Id', :path]]

end
