require  File.expand_path(File.dirname(__FILE__)) + "/../../downloads_spec_helper"

describe Downloads::PageRenderer, :type => :controller do
  controller_name :page
  integrate_views

  reset_domain_tables :downloads_item, :downloads_item_user, :end_user, :end_user_cache, :domain_file

  def generate_page_renderer(paragraph, options={}, inputs={})
    @rnd = build_renderer('/page', '/downloads/page/' + paragraph, options, inputs)
  end

  before do
    test_activate_module(:shop,:shop_currency => "USD")
    test_activate_module(:downloads)
  end

  describe "Downloads Tests" do
    before(:each) do
      @file = DomainFile.create :filename => fixture_file_upload("files/rails.png")
      @download = DownloadsItem.create :domain_file_id => @file.id, :name => 'My Download'
    end

    after(:each) do
      @file.destroy
    end

    it "should render the notifications paragraph" do
      @download.id.should_not be_nil
      @rnd = generate_page_renderer('downloads')
      @rnd.should_render_feature('downloads_page_downloads')
      renderer_get @rnd
    end

    it "should render the notifications paragraph" do
      mock_user
      @download.allow_user @myself
      @rnd = generate_page_renderer('downloads')
      @rnd.should_render_feature('downloads_page_downloads')
      renderer_get @rnd
    end

    it "should start the download" do
      mock_user
      @item_user = @download.allow_user @myself
      @item_user.id.should_not be_nil
      @item_user.end_user_id.should == @myself.id
      @rnd = generate_page_renderer('downloads', {}, :input => [:id, @item_user.id])
      @rnd.should_receive(:data_paragraph).once.with(:domain_file => @file)
      renderer_get @rnd
    end

    it "should not start the download" do
      mock_user
      @user2 = EndUser.push_target 'test2@test.dev'
      @item_user = @download.allow_user @user2
      @item_user.id.should_not be_nil
      @item_user.end_user_id.should == @user2.id
      @rnd = generate_page_renderer('downloads', {}, :input => [:id, @item_user.id])
      lambda { renderer_get @rnd }.should raise_exception(SiteNodeEngine::MissingPageException)
    end

    it "should not start the download" do
      @user2 = EndUser.push_target 'test2@test.dev'
      @item_user = @download.allow_user @user2
      @item_user.id.should_not be_nil
      @item_user.end_user_id.should == @user2.id
      @rnd = generate_page_renderer('downloads', {}, :input => [:id, @item_user.id])
      lambda { renderer_get @rnd }.should raise_exception(SiteNodeEngine::MissingPageException)
    end

    it "should not start the download" do
      @rnd = generate_page_renderer('downloads', {}, :input => [:id, 9999])
      lambda { renderer_get @rnd }.should raise_exception(SiteNodeEngine::MissingPageException)
    end
  end
end
