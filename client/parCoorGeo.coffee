Meteor.startup( () ->
  Session.set("selected_data", [])
  Session.set("all_data", [])
  true

  window.clearMap = ->
    m = window.map
    for i of m._layers
      if m._layers[i]._path?
        try
          m.removeLayer m._layers[i]
        catch e
          console.log "problem with " + e + m._layers[i]
    return


  window.refresh_map_circles = ->
    Template.map.circles = []
    do_once = () -> 
      try
        _.each(Session.get("selected_data"), (r) ->
          #get lat & lng
          geoR = r['Geo Response']
          latlng = geoR.slice(7, geoR.length-1).split(" ")
          Template.map.circles.push(L.circle(latlng, 20, {color: "#0055AA"}).addTo(window.map))
        )
      catch
        Meteor.setTimeout(do_once, 50)

    do_once()
)

Template.map.rendered = () ->
  # create a map in the "map" div, set the view to a given place and zoom
  window.map = L.map('map').setView([37.1186345815659, 36.1918842916073], 12);

  # add an OpenStreetMap tile layer
  L.tileLayer('http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png', {
	  attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
	  subdomains: 'abcd',
	  minZoom: 0,
	  maxZoom: 18
  }).addTo(window.map);

  setTimeout(window.refresh_map_circles, 500)

Template.parallel_coor.rendered = () ->
  parcoords = d3.parcoords()("#map_filter")
  Template.parallel_coor.parcoords = parcoords
  #parcoords.mode("queue").rate(20)

  d3.csv("_results.csv", (d)->
    Session.set("all_data",d)
    Session.set("selected_data",d)
    parcoords
      .data(d)
      .color("steelblue")
      .alpha(0.4)
      .detectDimensions()
      .render()
      .brushMode("1D-axes"); 
  )

  Template.parallel_coor.parcoords.on "brush", () ->
    window.clearMap()
    brushed = Template.parallel_coor.parcoords.brushed()
    Session.set("selected_data", brushed)
    window.refresh_map_circles()
