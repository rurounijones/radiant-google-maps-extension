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
  tag('google_map:header') { |tag| GMap.header(:host => request.host) }


  desc %{
    Generates the named google map in the using the div name specified. The div will need to be sized using CSS.

    The map can be identified by either it's id or name. If a marker is specified using marker_id or marker_name then the map will be centered on the marker.

    *Usage:*

    <pre><code><r:google_map:generate [div="string"] [id="number"] [name="string"] [marker_id="number"] [marker_name="string"]></code>></pre>

  }
  tag('google_map:generate') do |tag|
    raise TagError.new("`google_map:generate' tag must contain a `div' attribute.") unless tag.attr.has_key?('div')
    raise TagError.new("`google_map:generate' tag must contain a `name' or 'id' attribute.") unless tag.attr.has_key?('name') || tag.attr.has_key?('id')

    dbmap = find_map(tag.attr['id'],tag.attr['name'])

    if tag.attr.has_key?('marker_id') || tag.attr.has_key?('marker_name')
      dbmarker = find_marker(dbmap, tag.attr['marker_id'], tag.attr['marker_name'] )
    end

    gmap = generate_initial_map_javascript(dbmap, dbmarker, tag.attr['div'], tag.globals.page)

    tag.locals.map = gmap
    tag.expand
    gmap.to_html
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

  private

  def find_map(id, name)
    begin
      dbmap = id ? GoogleMap.find(id, :include => :markers) : GoogleMap.find_by_name(name, :include => :markers)
    rescue ActiveRecord::RecordNotFound
      raise TagError.new("No map found with ID: #{id}")
    end
    raise TagError.new("No map found with name: #{name}") if dbmap.nil?
    return dbmap
  end

  def find_marker(dbmap, id, name)
    unless id.blank?
      begin
        main_marker = dbmap.markers.find(id)
      rescue ActiveRecord::RecordNotFound
        raise TagError.new("No marker found with ID: #{id}")
      end
    else
      main_marker = dbmap.markers.find_by_name(name) unless name.blank?
      raise TagError.new("No marker found with name: #{name}") if main_marker.nil?
    end
    return main_marker
  end

  def generate_initial_map_javascript(dbmap, dbmarker, div, context)
    gmap = GMap.new(div)
    gmap.set_map_type_init(GoogleMap::VALID_MAP_TYPES.index(dbmap.style))
    gmap.control_init(:large_map => true,:map_type => true)

    if dbmarker
      gmap.center_zoom_init([dbmarker.position.y,dbmarker.position.x],dbmarker.zoom)
    else
      gmap.center_zoom_init([dbmap.center.y,dbmap.center.x],dbmap.zoom)
    end

    pagecontext = PageContext.new(context)
    parser = Radius::Parser.new(pagecontext, :tag_prefix => 'r')

    dbmap.markers.each do |marker|
      text = marker.content
      text = parser.parse(text)
      text = marker.filter.filter(text) if marker.respond_to? :filter_id
      text.gsub!('/', '\/') unless marker.respond_to? :filter_id
	  gmap.overlay_init GMarker.new([marker.position.y, marker.position.x],:title => marker.title, :info_window => text)
    end

    return gmap
  end


end
