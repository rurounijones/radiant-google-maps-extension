class MarkersDataset < Dataset::Base

  def load
  create_marker "first", :google_map_id => 1, :title => "First Marker", :latitude => 0, :longitude => 0, :content => "test"
  create_marker "markdown", :google_map_id => 1, :title => "Markdown Marker", :latitude => 0, :longitude => 0, :filter_id => "Markdown", :content => "**markdown**"
  end

  helpers do
    def create_marker(name, attributes={})
      create_record :marker, name.symbolize, marker_injection_params(attributes.reverse_merge(:name => name))
    end

    def marker_params(attributes={})
      name = attributes[:name] || unique_marker_name
      {
        :name => name,
        :title => "#{name} Title",
        :google_map_id => 1,
        :content => "Content",
        :latitude => 0,
        :longitude => 0
      }.merge(attributes)
    end

    # Used to create test records directly using SQL, replace the Lat/Lon with the derived values in :position.
    def marker_injection_params(attributes={})
      name = attributes[:name] || unique_marker_name
      merged_attributes = {
        :name => name,
        :position => Point.from_x_y(attributes[:longitude],attributes[:latitude],4326),
      }.merge(attributes)

      merged_attributes.reject {|key, value| key == :latitude || key == :longitude }

    end

    private

      @@unique_marker_name_call_count = 0
      def unique_marker_name
        @@unique_marker_name_call_count += 1
        "marker-#{@@unique_marker_name_call_count}"
      end
  end

end