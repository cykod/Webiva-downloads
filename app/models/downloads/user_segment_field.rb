

class Downloads::UserSegmentField < UserSegment::FieldHandler


 extend ActionView::Helpers::NumberHelper

  def self.user_segment_fields_handler_info
    {
      :name => 'User Downloads',
      :domain_model_class => DownloadsItemUser
    }
  end

 class DownloadsItemType < UserSegment::FieldType
    def self.select_options
      DownloadsItem.select_options
    end

    register_operation :is, [['Item', :model, {:class => Downloads::UserSegmentField::DownloadsItemType}]]

    def self.is(cls, group_field, field, item_id)
      cls.scoped(:conditions => ["#{field} = ?", item_id])
    end
  end

  register_field :user_downloads,Downloads::UserSegmentField::DownloadsItemType, :field => :downloads_item_id, :name =>"Items Downloaded" , :display_field => 'item_name', :sortable => true
 register_field :user_downloaded_at, UserSegment::CoreType::DateTimeType, :field => :created_at, :name => 'Downloaded At', :combined_only => true

  def self.field_heading(field)
    self.user_segment_fields[field][:name]
  end

  def self.get_handler_data(ids, fields)
    DownloadsItemUser.find(:all, :conditions => {:end_user_id => ids}).group_by(&:end_user_id)
  end


  def self.field_output(user, handler_data, field)
    UserSegment::FieldType.field_output(user, handler_data, field)
  end

 
end
