module GoogleMapsTags
  include Radiant::Taggable

  class TagError < StandardError; end

  tag 'google_map' do |tag|
    tag.expand
  end

  desc %{
    Creates the javascript include tag with the appropriate API key to the google map javascripts stored at maps.google.com. Best used in the site layout page.

    *Usage:*

    <pre><code><r:google_map:header /></code></pre>
  }
  tag('google_map:header') { |tag| GMap.header }


  desc %{
    Generates the named google map in the using the div name specified. The div will need to be sized using CSS.

    The map can be identified by either it's id or name. If a marker is specified using marker_id or marker_name then the map will be centered on the marker.

    *Usage:*

    <pre><code><r:google_map:generate [div="string"] [id="number"] [name="string"] [marker_id="number"] [marker_name="string"]></code>></pre>

  }
  tag('google_map:generate') do |tag|
    raise TagError.new("`google_map:generate' tag must contain a `div' attribute.") unless tag.attr.has_key?('div')
    raise TagError.new("`google_map:generate' tag must contain a `name' or 'id' attribute.") unless tag.attr.has_key?('name') || tag.attr.has_key?('id')

    map = GoogleMap.map(tag.attr['div'],tag.attr['id'],tag.attr['name'],tag.attr['marker_id'],tag.attr['marker_name'],tag.globals.page)
    tag.locals.map = map
    tag.expand
    map.to_html
  end
  
  desc %{
    Adds a Location from the Locations Extension to the map. Specify either name or id of the location.

    *Usage:*

    <pre><code><r:google_map:generate:location [id="number"] [name="string"] ></code>></pre>

  }
  tag('google_map:generate:location') do |tag|
    raise TagError.new("`google_map:generate' tag must contain a `name' or 'id' attribute.") unless tag.attr.has_key?('name') || tag.attr.has_key?('id')
    map = tag.locals.map
    location = Location.find_by_name(tag.attr['name'])
    map.overlay_init GMarker.new([location.lat, location.lng],:title => location.title, :info_window => "info text")

  end
  desc %{
    Adds a Location from the GeoInfo Extension to the map. Specify either name or id of the location.

    *Usage:*

    <pre><code><r:google_map:generate:geolocation [id="number"] [name="string"] ></code>></pre>

  }
  tag('google_map:generate:geolocation') do |tag|
    raise TagError.new("`google_map:generate' tag must contain a `name' or 'id' attribute.") unless tag.attr.has_key?('name') || tag.attr.has_key?('id')
    map = tag.locals.map
    location = GeoinfoLocation.find_by_name(tag.attr['name'])
    map.overlay_init GMarker.new([location.lat, location.lng],:title => location.name, :info_window => "info text")

  end


end
