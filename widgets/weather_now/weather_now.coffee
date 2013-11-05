class Dashing.WeatherNow extends Dashing.Widget
  @accessor 'current_icon', ->
    getIcon(@get('current.icon'))

  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
    console.log data
    # Handle incoming data
    @currentBg(@get('current.temperature'))
    @getWindDirection(@get('current.wind_bearing'))

    # flash the html node of this widget each time data comes in
    $(@node).fadeOut().fadeIn()

  currentBg: (temp) ->
    @set 'right_now_bg', "widget widget-weather-now " + WeatherShared.getBackground(temp)

  getWindDirection: (windBearing) ->
    @set 'wind_bearing', getWindDirection(windBearing)


