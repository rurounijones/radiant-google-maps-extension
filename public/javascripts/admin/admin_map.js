// Sets the zoon field value based on the map value
function SetZoomFieldValue(map){

  if ($('google_map_zoom') == undefined) {
    $('marker_zoom').value = map.getZoom();
  }
  else
  {
    $('google_map_zoom').value = map.getZoom();
  }
}

// Custom zoom that also update the form field
function GAdminMapControl() {
}

GAdminMapControl.prototype = new GControl();
GAdminMapControl.prototype.initialize = function(map) {
  var container = document.createElement("div");

  var zoomInDiv = document.createElement("div");
  this.setButtonStyle_(zoomInDiv);
  container.appendChild(zoomInDiv);
  zoomInDiv.appendChild(document.createTextNode("Zoom In"));
  GEvent.addDomListener(zoomInDiv, "click", function() {
    map.zoomIn();
    SetZoomFieldValue(map);
  });

  var zoomOutDiv = document.createElement("div");
  this.setButtonStyle_(zoomOutDiv);
  container.appendChild(zoomOutDiv);
  zoomOutDiv.appendChild(document.createTextNode("Zoom Out"));
  GEvent.addDomListener(zoomOutDiv, "click", function() {
    map.zoomOut();
    SetZoomFieldValue(map);
  });

  map.getContainer().appendChild(container);
  return container;
}

GAdminMapControl.prototype.getDefaultPosition = function() {
  return new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(7, 7));
}

GAdminMapControl.prototype.setButtonStyle_ = function(button) {
  button.style.textDecoration = "none";
  button.style.color = "#000000";
  button.style.backgroundColor = "white";
  button.style.font = "small Arial";
  button.style.border = "1px solid black";
  button.style.padding = "2px";
  button.style.marginBottom = "3px";
  button.style.textAlign = "center";
  button.style.width = "6em";
  button.style.cursor = "pointer";
}
