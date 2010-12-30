
class Downloads::AdminController < ModuleController

  component_info 'Downloads', :description => 'Downloads support', :access => :private, :dependencies => ['shop']

  # Register a handler feature
  register_permission_category :downloads, "Downloads" ,"Permissions related to Downloads"
  
  register_permissions :downloads, [[:manage, 'Manage Downloads', 'Manage Downloads'],
                                    [:config, 'Configure Downloads', 'Configure Downloads' ]
                                   ]

  content_model :downloads

  permit 'downloads_config'

  register_handler :members, :view,  "Downloads::ManageUserController"

  public

  def self.get_downloads_info
    [
      {:name => 'Downloads', :url => {:controller => '/downloads/manage', :action => 'downloads'}, :permission => 'downloads_manage', :icon => 'icons/content/feedback.gif'}
    ]
  end
end
