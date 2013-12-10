@Wallgig ||= {}
class @Wallgig.Utilities
  @alert: (title, body) ->
    $(JST['modal'](title: title, body: body)).modal()