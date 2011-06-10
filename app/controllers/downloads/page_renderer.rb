
class Downloads::PageRenderer < ParagraphRenderer

  features '/downloads/page_feature'

  paragraph :downloads
  paragraph :automatic_downloads

  def downloads
    conn_type, conn_id = page_connection
    if conn_type == :id && ! conn_id.blank?
      @item_user = DownloadsItemUser.find_by_id conn_id
      raise SiteNodeEngine::MissingPageException.new( site_node, language ) unless @item_user
      raise SiteNodeEngine::MissingPageException.new( site_node, language ) unless @item_user.end_user_id == myself.id
      DownloadsUser.push_user(@item_user.downloads_item_id,myself.id)
      data_paragraph :domain_file => @item_user.downloads_item.domain_file
      return
    end

    @downloads = DownloadsItemUser.find(:all, :conditions => {:end_user_id => myself.id}, :include => :downloads_item).map(&:downloads_item) if myself.id
    render_paragraph :feature => :downloads_page_downloads
  end


  def automatic_downloads
    @options = paragraph_options(:automatic_downloads)

    conn_type, conn_id = page_connection
    if conn_type == :id && ! conn_id.blank?
      if @options.downloads_ids.include?(conn_id.to_i)
        if myself.id 
          item = DownloadsItem.find_by_id(conn_id)

          DownloadsUser.push_user(item.id,myself.id)

          run_triggered_actions('action', item, myself)

          if item.domain_file.local?
            return data_paragraph :domain_file => item.domain_file
          else
            redirect_to item.domain_file.url
          end
        else
          session[:lock_lockout] = controller.request.request_uri      
          return redirect_paragraph @options.redirect_page_url
        end
      end
    end

    @downloads = DownloadsItem.find(:all,:conditions => { :id => @options.downloads_ids })

    render_paragraph :feature => :downloads_page_downloads
  end
end
