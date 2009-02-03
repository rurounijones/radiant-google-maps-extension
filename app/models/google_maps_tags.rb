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
  tag('google_map:generate') do |tag|
    raise TagError.new("`google_map:display' tag must contain a `div' attribute.") unless tag.attr.has_key?('div')
    raise TagError.new("`google_map:display' tag must contain a `name' attribute.") unless tag.attr.has_key?('name')

    GoogleMap.generate_html(tag.attr['name'],tag.attr['div'],tag.globals.page)

  end

end
