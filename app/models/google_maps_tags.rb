module GoogleMapsTags
  include Radiant::Taggable

  tag 'google_map' do |tag|
    tag.expand
  end

  desc %{
    Creates the javascript include tag with the appropriate API key to the google map javascripts stored at maps.google.com

    Best used in the site layout page.
  }
  tag('google_map:header') { |tag| GMap.header }


  desc %{
    Generates the named google map in the using the div name specified. The div will need to be sized using CSS.
  }
  tag('google_map:create') do |tag|
    raise TagError.new("`google_map:display' tag must contain a `div' attribute.") unless tag.attr.has_key?('div')
    raise TagError.new("`google_map:display' tag must contain a `name' attribute.") unless tag.attr.has_key?('name')
    @stored_map = GoogleMap.find_by_name(tag.attr['name'])
    return "<p>No map found with the name '#{tag.attr['name']}'</p>" if @stored_map == nil
    @map = GMap.new(tag.attr['div'])
    @map.control_init(:large_map => true,:map_type => true)
	  @map.center_zoom_init([@stored_map.center.x,-@stored_map.center.y],@stored_map.zoom)
    @map.to_html
  end

end
