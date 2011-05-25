
class Downloads::PageController < ParagraphController

  editor_header 'Downloads Paragraphs'

  editor_for :downloads, :name => "Downloads", :feature => :downloads_page_downloads, :no_options => true,
                         :inputs => [[:id, 'Download Item Id', :path]]

  editor_for :automatic_downloads, :name => 'Automatic Downloads', :feature => :downloads_page_downloads,
    :inputs => [[:id, 'Download Item Id', :path]]


  class AutomaticDownloadsOptions < HashModel
    attributes :downloads_ids => [], :redirect_page_id => nil

    integer_array_options :downloads_ids
    page_options :redirect_page_id

    options_form(
      fld(:downloads_ids, :select, :options => Proc.new { DownloadsItem.select_options } , :html => {:multiple => true, :size => 5 }), 
      fld(:redirect_page_id, :page_selector)
    )
  end
end
