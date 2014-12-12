Meteor.methods
  uploadFile: (userId, fileName, fileUrl) ->
    console.log("uploaded file to " + fileUrl)
    Meteor.Uploads.insert({userId: userId, name: fileName, fileUrl: fileUrl})
    return true

  delete_data: (userId, fileName) ->
    #first find url to delete file from s3
    filePath = Meteor.Uploads.findOne({userName: userName, fileName: fileName})['fileUrl'].split('/').slice(4).join("/")
    if filePath[0]!="/"
      filePath = "/"+filePath
      
    console.log("filePath=" + filePath)
    #Meteor.Uploads.remove({fileName: fileName})
    