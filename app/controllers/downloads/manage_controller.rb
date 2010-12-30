
class Downloads::ManageController < ModuleController
  permit 'downloads_manage'

  component_info 'Downloads'

  cms_admin_paths 'content',
                  'Content'   => {:controller => '/content'},
                  'Downloads'   => {:action => 'downloads'}

  # need to include
  include ActiveTable::Controller
  active_table :download_table,
                DownloadsItem,
                [ :check,
                  :name,
                  hdr(:static, 'File'),
                  :description,
                  hdr(:static, :num_allowed_users, :label => '# Users'),
                  :created_at,
                  :updated_at
                ]

  def display_download_table(display=true)
    active_table_action 'download' do |act,ids|
      case act
      when 'delete': DownloadsItem.destroy(ids)
      end
    end

    @active_table_output = download_table_generate params, :order => :updated_at

    render :partial => 'download_table' if display
  end

  def downloads
    cms_page_path ['Content'], 'Downloads'
    display_download_table(false)
  end

  def download
    @download = DownloadsItem.find(params[:path][0]) if params[:path][0]
    @download ||= DownloadsItem.new

    if request.post? && params[:download]
      if params[:commit]
        if @download.update_attributes params[:download]
          redirect_to :action => 'downloads'
        end
      else
        redirect_to :action => 'downloads'
      end
    end

    cms_page_path ['Content', 'Downloads'], @download.id ? 'Edit Download' : 'Create Download'
  end

  active_table :user_table,
                DownloadsItemUser,
                [ hdr(:static, 'Name'),
                  :created_at
                ]

  def display_user_table(display=true)
    @download ||= DownloadsItem.find params[:path][0]

    active_table_action 'user' do |act,ids|
      case act
      when 'delete': DownloadsItemUser.destroy(ids)
      end
    end

    @active_table_output = user_table_generate params, :conditions => ['downloads_item_id = ?', @download.id], :include => [:downloads_item, :end_user], :order => :created_at

    render :partial => 'user_table' if display
  end

  def users
    @download = DownloadsItem.find params[:path][0]
    cms_page_path ['Content', 'Downloads'], @download.name
    display_user_table(false)
  end
end
