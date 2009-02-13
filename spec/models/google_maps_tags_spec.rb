require File.dirname(__FILE__) + '/../spec_helper'

describe "Google Maps Tags" do
  dataset :google_maps_tags

  it '<r:google_map:header /> should render the header' do
    page(:map)
    page.should render('<r:google_map:header />').as('<script src="http://maps.google.com/maps?file=api&amp;v=2.x&amp;key=ABQIAAAAzMUFFnT9uH0xq39J0Y4kbhTJQa0g3IQ9GZqIMmInSLzwtGDKaBR6j135zrztfTGVOm2QlWnkaidDIQ&amp;hl=" type="text/javascript"></script>
<script src="/javascripts/ym4r-gm.js" type="text/javascript"></script>
<style type="text/css">
 v:* { behavior:url(#default#VML);}
</style>')
    
  end
  
  it "<r:google_map:generate name='parent' div='mapDiv' /> with a valid map should render the google map" do
    page(:map)
    page.should render("<r:google_map:generate name='parent' div='mapDiv' />").as('<script type="text/javascript">
var map;
window.onload = addCodeToFunction(window.onload,function() {
if (GBrowserIsCompatible()) {
map = new GMap2(document.getElementById("mapDiv"));
map.setCenter(new GLatLng(0.0,0.0),15);map.addOverlay(addInfoWindowToMarker(new GMarker(new GLatLng(0.0,0.0),{title : "First Marker"}),"test",{}));
map.addOverlay(addInfoWindowToMarker(new GMarker(new GLatLng(0.0,0.0),{title : "Markdown Marker"}),"<p><strong>markdown</strong></p>",{}));map.addControl(new GLargeMapControl());
map.addControl(new GMapTypeControl());
}
});
</script>')  
  end

  it "<r:google_map:generate name='parent' div='mapDiv' /> with an invalid map should render a simple error message" do
    page(:map)
    page.should render("<r:google_map:generate name='nonexisting' div='mapDiv' />").as("<p>No map found with the name 'nonexisting'</p>")
  end

  private

  def page(symbol = nil)
    if symbol.nil?
      @page ||= pages(:assorted)
    else
      @page = pages(symbol)
    end
  end
end


