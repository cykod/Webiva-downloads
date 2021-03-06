
class Downloads::AdminController < ModuleController

  component_info 'Downloads', :description => 'Downloads support', :access => :private

  # Register a handler feature
  register_permission_category :downloads, "Downloads" ,"Permissions related to Downloads"
  
  register_permissions :downloads, [[:manage, 'Manage Downloads', 'Manage Downloads'],
                                    [:config, 'Configure Downloads', 'Configure Downloads' ]
                                   ]

  register_handler :user_segment, :fields, 'Downloads::UserSegmentField'

  content_model :downloads

  permit 'downloads_config'

  register_handler :members, :view,  "Downloads::ManageUserController"
  register_handler :shop, :product_feature, "Downloads::AddDownloadShopFeature"


  public

  def self.get_downloads_info
    [
      {:name => 'Downloads', :url => {:controller => '/downloads/manage', :action => 'downloads'}, :permission => 'downloads_manage', :icon => 'icons/content/feedback.gif'}
    ]
  end
end
