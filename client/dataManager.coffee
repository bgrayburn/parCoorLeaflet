dropCsvFromName = (fn) ->
  return fn.split('.').slice(0,-1).join('.')

Template.data_manager.events 

  "click button.upload": ->
    files = $("input.file_bag")[0].files
    S3.upload files, "/", (e, r) ->
      console.log("about to upload file")
      Meteor.call("uploadFile", Meteor.userId(), dropCsvFromName(files[0].name), r.url)  
      window.updateUserFiles()
      return

    Session.set("userFiles", Meteor.Uploads.find({userId: Meteor.userId}))
    return

  "click button.data_switch": (e)->
    $(e.target).toggleClass("active")
    #first update all_data
    window.update_active_data()
    return


  "click button.data_delete": -> (e)->
    Meteor.methods("delete_data", Meteor.userId(), e.getAttribute("data-target"))
  
Template.data_manager.helpers
  files: ->
    S3.collection.find()

  userFiles: ->
    out = []
    ufs = Session.get("userFiles")
    if ufs
      out = ufs
