require  File.expand_path(File.dirname(__FILE__)) + "/../../downloads_spec_helper"

describe Downloads::ManageUserController do

  reset_domain_tables :downloads_item, :downloads_item_user, :end_user, :end_user_cache

  describe "Download Tests" do
    before(:each) do
      mock_editor
      @download = DownloadsItem.create :domain_file_id => 2, :name => 'My Download'
      @download2 = DownloadsItem.create :domain_file_id => 3, :name => 'My 2nd Download'
      @user = EndUser.push_target 'test1@test.dev'
      @download.allow_user @user
    end

    it "should display the view page" do
      get 'view', :path => [@user.id], :tab => 1
    end

    it "should handle download table list" do
      controller.should handle_active_table(:download_table) do |args|
        args ||= {}
        args[:path] = [@user.id]
        args[:tab] = 1
        post 'display_download_table', args
      end
    end

    it "should display the download page" do
      get 'download', :path => [@user.id], :tab => 1
    end

    it "should create a new download for the user" do
      assert_difference 'DownloadsItemUser.count', 1 do
        post 'download', :path => [@user.id], :tab => 1, :commit => 1, :download => {:downloads_item_id => @download2.id}
      end

      item_user = DownloadsItemUser.last
      item_user.end_user_id.should == @user.id
    end
  end
end
