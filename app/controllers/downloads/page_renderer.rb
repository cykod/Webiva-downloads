
class Downloads::PageRenderer < ParagraphRenderer

  features '/downloads/page_feature'

  paragraph :downloads

  def downloads
    conn_type, conn_id = page_connection
    if conn_type == :id && ! conn_id.blank?
      @item_user = DownloadsItemUser.find_by_id conn_id
      raise SiteNodeEngine::MissingPageException.new( site_node, language ) unless @item_user
      raise SiteNodeEngine::MissingPageException.new( site_node, language ) unless @item_user.end_user_id == myself.id
      data_paragraph :domain_file => @item_user.downloads_item.domain_file
      return
    end

    @downloads = DownloadsItemUser.find(:all, :conditions => {:end_user_id => myself.id}, :include => :downloads_item) if myself.id
    render_paragraph :feature => :downloads_page_downloads
  end
end
