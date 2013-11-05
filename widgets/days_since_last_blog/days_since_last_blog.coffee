class Dashing.DaysSinceLastBlog extends Dashing.Widget
  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
    console.log(data)
    if data.published_date
      @set('from_now', "foo") # moment(data.published_date).from_now())
      # if data.published_date == "green"
      #     $(@node).css( "background-color", "#8DD15A")
      # if data.status == "yellow"
      #     $(@node).css( "background-color", "#D1CD5A")
      # if data.status == "red"
      #     $(@node).css( "background-color", "#D15A5A")


