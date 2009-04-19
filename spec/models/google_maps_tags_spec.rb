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

  it "<r:google_map:generate name='parent' /> should error with invalid 'div' attribute" do
    page(:map)
    page.should render("<r:google_map:generate name='parent' />").with_error("`google_map:generate' tag must contain a `div' attribute.")
   end

  it "<r:google_map:generate div='mapDiv'/> should error with invalid 'id' or 'name' attribute" do
    page(:map)
    page.should render("<r:google_map:generate div='mapDiv' />").with_error("`google_map:generate' tag must contain a `name' or 'id' attribute.")
   end

  it "<r:google_map:generate div='mapDiv'/> with invalid map id or name should display 'not found' tag" do
    page(:map)
    page.should render("<r:google_map:generate div='mapDiv' id='500' />").as("<p>Map with id '500' not found</p>")
    page.should render("<r:google_map:generate div='mapDiv' name='nonexistant' />").as("<p>Map with name 'nonexistant' not found</p>")
   end

  it "<r:google_map:generate div='mapDiv' name='parent' marker_name='first' /> with a valid map and marker name should render the google map centered on the marker" do
    page(:map)
    page.should render("<r:google_map:generate name='parent' div='mapDiv' marker_name='first' />").as('<script type="text/javascript">
var map;
window.onload = addCodeToFunction(window.onload,function() {
if (GBrowserIsCompatible()) {
map = new GMap2(document.getElementById("mapDiv"));
map.setCenter(new GLatLng(1.0,1.0),15);map.setMapType(G_NORMAL_MAP);
map.addOverlay(addInfoWindowToMarker(new GMarker(new GLatLng(1.0,1.0),{title : "First Marker"}),"test",{}));
map.addOverlay(addInfoWindowToMarker(new GMarker(new GLatLng(2.0,2.0),{title : "Markdown Marker"}),"<p><strong>markdown<\/strong><\/p>",{}));map.addControl(new GLargeMapControl());
map.addControl(new GMapTypeControl());
}
});
</script>')
  end

  it "<r:google_map:generate div='mapDiv' name='parent' marker_id='1' /> with a valid map and marker id should render the google map centered on the marker" do
    page(:map)
    page.should render("<r:google_map:generate name='parent' div='mapDiv' marker_name='first' />").as('<script type="text/javascript">
var map;
window.onload = addCodeToFunction(window.onload,function() {
if (GBrowserIsCompatible()) {
map = new GMap2(document.getElementById("mapDiv"));
map.setCenter(new GLatLng(1.0,1.0),15);map.setMapType(G_NORMAL_MAP);
map.addOverlay(addInfoWindowToMarker(new GMarker(new GLatLng(1.0,1.0),{title : "First Marker"}),"test",{}));
map.addOverlay(addInfoWindowToMarker(new GMarker(new GLatLng(2.0,2.0),{title : "Markdown Marker"}),"<p><strong>markdown<\/strong><\/p>",{}));map.addControl(new GLargeMapControl());
map.addControl(new GMapTypeControl());
}
});
</script>')
  end

  it "<r:google_map:generate div='mapDiv' name='parent' /> with a valid map name should render the google map" do
    page(:map)
    page.should render("<r:google_map:generate name='parent' div='mapDiv' />").as('<script type="text/javascript">
var map;
window.onload = addCodeToFunction(window.onload,function() {
if (GBrowserIsCompatible()) {
map = new GMap2(document.getElementById("mapDiv"));
map.setCenter(new GLatLng(0.0,0.0),15);map.setMapType(G_NORMAL_MAP);
map.addOverlay(addInfoWindowToMarker(new GMarker(new GLatLng(1.0,1.0),{title : "First Marker"}),"test",{}));
map.addOverlay(addInfoWindowToMarker(new GMarker(new GLatLng(2.0,2.0),{title : "Markdown Marker"}),"<p><strong>markdown<\/strong><\/p>",{}));map.addControl(new GLargeMapControl());
map.addControl(new GMapTypeControl());
}
});
</script>')
  end
  
  it "<r:google_map:generate div='mapDiv' id='1' /> with a valid map id should render the google map" do
    page(:map)
    page.should render("<r:google_map:generate name='parent' div='mapDiv' />").as('<script type="text/javascript">
var map;
window.onload = addCodeToFunction(window.onload,function() {
if (GBrowserIsCompatible()) {
map = new GMap2(document.getElementById("mapDiv"));
map.setCenter(new GLatLng(0.0,0.0),15);map.setMapType(G_NORMAL_MAP);
map.addOverlay(addInfoWindowToMarker(new GMarker(new GLatLng(1.0,1.0),{title : "First Marker"}),"test",{}));
map.addOverlay(addInfoWindowToMarker(new GMarker(new GLatLng(2.0,2.0),{title : "Markdown Marker"}),"<p><strong>markdown<\/strong><\/p>",{}));map.addControl(new GLargeMapControl());
map.addControl(new GMapTypeControl());
}
});
</script>')
  end

  it "<r:google_map:generate div='mapDiv' name='parent'/> with invalid marker id or name should display 'not found' tag" do
    page(:map)
    page.should render("<r:google_map:generate div='mapDiv' name='parent' marker_id='500' />").as("<p>Marker with id '500' not found</p>")
    page.should render("<r:google_map:generate div='mapDiv' name='parent' marker_name='nonexistant' />").as("<p>Marker with name 'nonexistant' not found</p>")
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


