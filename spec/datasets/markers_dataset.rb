class MarkersDataset < Dataset::Base

  def load
    create_google_map "parent", :latitude => "0", :longitude => "0", :description => "test", :zoom => "15" do
      create_marker "first", :title => "First Marker", :latitude => 1, :longitude => 1, :content => "test"
      create_marker "markdown", :title => "Markdown Marker", :latitude => 2, :longitude => 2, :filter_id => "Markdown", :content => "**markdown**"
    end
  end

  helpers do
    def create_marker(name, attributes={})
      create_record :marker, name.symbolize, marker_injection_params(attributes.reverse_merge(:name => name))
    end

    def create_google_map(name, attributes={})
      create_record :google_map, name.symbolize, google_map_injection_params(attributes.reverse_merge(:name => name))
      symbol = name.symbolize
      if block_given?
        @current_google_map_id = google_map_id(symbol)
        yield
      end
    end

    def google_map_injection_params(attributes={})
      name = attributes[:name] || unique_google_map_name
      merged_attributes = {
        :name => name,
        :center => Point.from_x_y(attributes[:longitude],attributes[:latitude],4326),
      }.merge(attributes)

      merged_attributes.reject {|key, value| key == :latitude || key == :longitude }

    end

    def marker_params(attributes={})
      name = attributes[:name] || unique_marker_name
      {
        :name => name,
        :title => "#{name} Title",
        :google_map_id => GoogleMap.first.id,
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
      merged_attributes[:google_map_id] = @current_google_map_id

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