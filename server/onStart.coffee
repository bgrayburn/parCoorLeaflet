Meteor.startup ->
  Meteor.publish("uploads", ()->
    return Meteor.Uploads.find({})
  )