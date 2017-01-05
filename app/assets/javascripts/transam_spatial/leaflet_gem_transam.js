// Register extensions to github.com/camsys/leaflet_gem

(function() {
  // get the map wrapper object/class
  var LeafletTransAM = leaflet_tools || {};

  // Add Zoom Slider control
  // Requires L.
  if(! LeafletTransAM.addZoomSlider) {
    LeafletTransAM.addZoomSlider = function() {
      var map = this.map();
      if(map && L.control.zoomslider) {
        //remove default zoomControl
        $('.leaflet-control-zoom').remove();
        this.zoomSliderControl = L.control.zoomslider().addTo(map);
      }
    };
  }

  // Add layers control
  if(! LeafletTransAM.addLayerControl) {
    LeafletTransAM.addLayerControl = function() {
      var map = this.map();
      if(map) {
        //add an empty layer switcher
        this.layerControl = L.control.layers().addTo(map);
      }
    };
  }

})();