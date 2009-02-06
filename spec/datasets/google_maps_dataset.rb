class GoogleMapsDataset < Dataset::Base

  def load
  create_google_map "first", :latitude => "0", :longitude => "0", :description => "test", :zoom => "15"
  end

  helpers do
    def create_google_map(name, attributes={})
      create_record :google_map, name.symbolize, google_map_injection_params(attributes.reverse_merge(:name => name))
    end

    def google_map_params(attributes={})
      name = attributes[:name] || unique_google_map_name
      {
        :name => name,
        :description => 'test',
        :latitude => 0,
        :longitude => 0,
        :zoom => 15
      }.merge(attributes)
    end

    # Used to create test records directly using SQL, replace the Lat/Lon with the derived values in :center.
    def google_map_injection_params(attributes={})
      name = attributes[:name] || unique_google_map_name
      merged_attributes = {
        :name => name,
        :description => 'test',
        :center => Point.from_x_y(attributes[:longitude],attributes[:latitude],4326),
        :zoom => 15
      }.merge(attributes)
      
      merged_attributes.reject {|key, value| key == :latitude || key == :longitude }

    end

    private

      @@unique_google_map_name_call_count = 0
      def unique_google_map_name
        @@unique_google_map_name_call_count += 1
        "google_map-#{@@unique_google_map_name_call_count}"
      end
  end

end