require  File.expand_path(File.dirname(__FILE__)) + "/../../downloads_spec_helper"

describe Downloads::ManageController do

  reset_domain_tables :downloads_item, :downloads_item_user, :end_user, :end_user_cache

  describe "Download Tests" do
    before(:each) do
      mock_editor
      @download = DownloadsItem.create :domain_file_id => 2, :name => 'My Download'
      @user1 = EndUser.push_target 'test1@test.dev'
      @user2 = EndUser.push_target 'test2@test.dev'
      @download.allow_user @user1
      @download.allow_user @user2
    end

    it "should render the downloads page" do
      get 'downloads'
    end

    it "should handle download table list" do
      controller.should handle_active_table(:download_table) do |args|
        post 'display_download_table', args
      end
    end

    it "should be able to delete a message" do
      assert_difference 'DownloadsItem.count', -1 do
        post 'display_download_table', :table_action => 'delete', :download => {@download.id => @download.id}
      end
      DownloadsItem.find_by_id(@download.id).should be_nil
    end

    it "should render the users page" do
      get 'users', :path => [@download.id]
    end

    it "should handle user table list" do
      controller.should handle_active_table(:user_table) do |args|
        args ||= {}
        args[:path] = [@download.id]
        post 'display_user_table', args
      end
    end

    it "should render create download form" do
      get 'download', :path => []
    end

    it "should render edit download form" do
      get 'download', :path => [@download.id]
    end

    it "should be able to create a download" do
      assert_difference 'DownloadsItem.count', 1 do
        post 'download', :path => [], :commit => 1, :download => {:domain_file_id => 3, :name => 'New Download'}
      end
      new_download = DownloadsItem.last
      new_download.name.should == 'New Download'
    end

    it "should be able to edit a download" do
      assert_difference 'DownloadsItem.count', 0 do
        post 'download', :path => [@download.id], :commit => 1, :download => {:domain_file_id => @download.domain_file_id, :name => 'New Download Name'}
      end
      @download.reload
      @download.name.should == 'New Download Name'
    end
  end
end
