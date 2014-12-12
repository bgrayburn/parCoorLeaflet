Template.map.rendered = () ->
  # create a map in the "map" div, set the view to a given place and zoom
  window.map = L.map('map').setView([37.1186345815659, 36.1918842916073], 12);

  # add an OpenStreetMap tile layer
  L.tileLayer('http://{s}.www.toolserver.org/tiles/bw-mapnik/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>'
  }).addTo(window.map);

  setTimeout(window.refresh_map_circles, 500)

