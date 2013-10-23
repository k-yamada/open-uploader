window.OU =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

class OU.Views.AppView extends Backbone.View
  el: "body"
  upload_area_showned: false
  events:
    "click #lnk_upload"              : "linkUploadClicked"

  initialize: =>

  linkUploadClicked: =>
    if @upload_area_showned
      @upload_area_showned = false
      $("#upload_area").hide("slow")
    else
      @upload_area_showned = true
      $("#upload_area").show("slow")

  render: =>
    return @