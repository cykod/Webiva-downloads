
class Downloads::AddDownloadShopFeature < Shop::ProductFeature

  def self.shop_product_feature_handler_info
    { 
      :name => 'Add a download item to a user',
      :callbacks => [ :purchase ],
      :options_partial => "/downloads/features/add_download"
    }
  end
  
  def purchase(user, order_item, session)
    options.download_item.allow_user(user) if options.download_item
  end

  def self.options(val)
    Options.new(val)
  end
  
  class Options < HashModel
    attributes :download_item_id => nil

    validates_presence_of :download_item_id

    options_form(
                 fld(:download_item_id, :select, :options => :download_item_options)
                 )

    def download_item_options
      DownloadsItem.select_options_with_nil
    end

    def download_item
      @download_item ||= DownloadsItem.find_by_id self.download_item_id
    end
  end
  
  
  def self.description(opts)
    opts = self.options(opts)
    sprintf("Add download %s", opts.download_item ? opts.download_item.name : 'NOT FOUND')
  end
end
