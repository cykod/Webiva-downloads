
class Downloads::ManageUserController < ModuleController
  permit 'downloads_manage'

  component_info 'Downloads'

  def self.members_view_handler_info
    {
      :name => 'Downloads',
      :controller => '/downloads/manage_user',
      :action => 'view'
    }
   end

  # need to include
  include ActiveTable::Controller
  active_table :download_table,
                DownloadsItemUser,
                [ :check,
                  hdr(:static, 'Name'),
                  :created_at
                ]

  def display_download_table(display=true)
    @user ||= EndUser.find params[:path][0]
    @tab = params[:tab]

    active_table_action 'download' do |act,ids|
      case act
      when 'delete': DownloadsItemUser.destroy(ids)
      end
    end

    @active_table_output = download_table_generate params, :conditions => ['end_user_id = ?', @user.id], :include => [:downloads_item], :order => :created_at

    render :partial => 'download_table' if display
  end

  def view
    @user = EndUser.find params[:path][0]
    @tab = params[:tab]
    display_download_table(false)
    render :partial => 'view'
  end

  def download
    @user = EndUser.find params[:path][0]
    @tab = params[:tab]
    @download = DownloadsItemUser.new :end_user_id => @user.id

    if request.post? && params[:download]
      @download.attributes = params[:download]

      if params[:commit] && @download.save
        render :update do |page|
          page << 'DownloadsData.viewDownloads();'
        end
        return
      end
    end

    render :partial => 'download'
  end
end
