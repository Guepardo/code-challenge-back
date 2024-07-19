module ApiUtils
  extend ActiveSupport::Concern

  included do
    def pagination_meta(collection)
      {
        current_page: collection.current_page,
        next_page: collection.next_page,
        prev_page: collection.prev_page,
        total_pages: collection.total_pages,
        total_count: collection.total_count
      }
    end

    def serialize_resource(resource, serializer)
      ActiveModelSerializers::SerializableResource.new(resource, each_serializer: serializer)
    end
  end
end
