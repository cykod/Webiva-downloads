
class Downloads::PageRenderer < ParagraphRenderer

  features '/downloads/page_feature'

  paragraph :downloads

  def downloads
    @options = paragraph_options :downloads

    render_paragraph :feature => :downloads_page_downloads
  end
end
