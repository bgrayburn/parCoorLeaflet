Template.parallel_coor.rendered = () ->
  parcoords = d3.parcoords()("#map_filter")
  Template.parallel_coor.parcoords = parcoords
  #parcoords.mode("queue").rate(20)
  Session.set("selected_data",[])

  Template.parallel_coor.parcoords.on "brush", () ->
    window.clearMap()
    brushed = Template.parallel_coor.parcoords.brushed()
    Session.set("selected_data", brushed)
    window.refresh_map_circles()

window.update_active_data = ->
  active_data_array = $('.data_switch.active').map((a,b)->
    Meteor.Uploads.findOne({name: b.innerText})
    )
  window.active_data_array = active_data_array
  Session.set("active_data", active_data_array)

#check out which data points are active
Tracker.autorun ->
  active_datas = Session.get("active_data")
  if active_datas
    for f in active_datas
      Papa.parse(f.url, {
        download: true,
        complete: (results)->
          Template.parallel_coor.parcoords
            .data(results)
            .color("steelblue")
            .alpha(0.4)
            .detectDimensions()
            .render()
            .brushMode("1D-axes"); 
      });

