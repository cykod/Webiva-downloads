require  File.expand_path(File.dirname(__FILE__)) + "/../downloads_spec_helper"

describe DownloadsItem do

  reset_domain_tables :downloads_item, :downloads_item_user, :end_user, :end_user_cache

  it "should require domain_file and name" do
    @item = DownloadsItem.new
    @item.valid?

    @item.should have(1).error_on(:domain_file_id)
    @item.should have(1).error_on(:name)
  end

  it "should be able to create a download item" do
    @item = DownloadsItem.create :domain_file_id => 2, :name => 'My Test Download'
    @item.id.should_not be_nil
  end

  it "should allow and revoke a user from a download item" do
    @user = EndUser.push_target 'test@test.dev'
    @item = DownloadsItem.create :domain_file_id => 2, :name => 'My Test Download'

    assert_difference 'DownloadsItemUser.count', 1 do
      @item_user = @item.allow_user @user
    end

    @item_user.id.should_not be_nil
    @item.can_download?(@user).should be_true

    @item.reload
    assert_difference 'DownloadsItemUser.count', 0 do
      @item_user = @item.allow_user @user
    end

    @item_user.id.should_not be_nil
    @item.can_download?(@user).should be_true

    @item.reload
    assert_difference 'DownloadsItemUser.count', -1 do
      @item.revoke_user @user
    end

    @item_user = DownloadsItemUser.find_by_id @item_user.id
    @item_user.should be_nil
    @item.can_download?(@user).should be_false

    @item.reload
    assert_difference 'DownloadsItemUser.count', 0 do
      @item.revoke_user @user
    end

    @item.can_download?(@user).should be_false
  end

  it "should clean up" do
    @user1 = EndUser.push_target 'test1@test.dev'
    @user2 = EndUser.push_target 'test2@test.dev'
    @item = DownloadsItem.create :domain_file_id => 2, :name => 'My Test Download'

    assert_difference 'DownloadsItemUser.count', 2 do
      @item.allow_user @user1
      @item.allow_user @user2
    end

    assert_difference 'DownloadsItemUser.count', -2 do
      @item.destroy
    end

    @item_user = DownloadsItemUser.first :conditions => {:downloads_item_id => @item.id, :end_user_id => @user1.id}
    @item_user.should be_nil
  end
end
