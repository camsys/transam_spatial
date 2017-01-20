// Register extensions to github.com/camsys/leaflet_gem

(function() {
  // get the map wrapper object/class
  var LeafletTransAM = leaflet_tools || {};

  // Add Zoom Slider control
  if(! LeafletTransAM.addZoomSliderControl) {
    LeafletTransAM.addZoomSliderControl = function() {
      var map = this.map();
      if(map && L.control.zoomslider) {
        //remove default zoomControl
        if(map.zoomControl) {
          map.zoomControl.removeFrom(map);
          map.zoomControl = null;
        } else {
          $('.leaflet-control-zoom').remove();
        }
        this.zoomSliderControl = L.control.zoomslider().addTo(map);
      }
    };
  }

  // Add full screen control
  if(! LeafletTransAM.addFullscreenControl) {
    LeafletTransAM.addFullscreenControl = function(fullScreenEl) {
      var map = this.map();
      if(map && L.control.fullscreen) {
        this.fullscreenControl = L.control.fullscreen({
          fullScreenEl: fullScreenEl
        }).addTo(map);
      }
    };
  }

  // Add layers control
  if(! LeafletTransAM.addLayerControl) {
    LeafletTransAM.addLayerControl = function() {
      var map = this.map();
      if(map) {
        //add an empty layer switcher
        this.layerControl = L.control.groupedLayers().addTo(map);
      }
    };
  }

  // Add expandable sidebar onto the map container
  if(! LeafletTransAM.addSidebar) {
    LeafletTransAM.addSidebar = function(sidebarId) {
      var map = this.map();
      if(map && L.control.sidebar) {
        this.sidebarControl = L.control.sidebar(sidebarId).addTo(map);
      }
    };
  }
  

})();