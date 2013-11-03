class Dashing.WeatherToday extends Dashing.Widget

  @accessor 'day_icon', ->
    getIcon(@get('today.icon'))

  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
    # Handle incoming data
    @todayBg(@get('today.high'), @get('today.low'))
    @getTime()

    # flash the html node of this widget each time data comes in
    $(@node).fadeOut().fadeIn()

  currentBg: (temp) ->
    @set 'right_now', @getBackground(temp)

  todayBg: (high, low) ->
    averageRaw = (high + low) / 2
    average = Math.round(averageRaw)

    @set 'today_bg', "widget widget-weather-today " + WeatherShared.getBackground(average)

  getTime: (now = new Date()) ->
    hour = now.getHours()
    minutes = now.getMinutes()
    minutes = if minutes < 10 then "0#{minutes}" else minutes
    ampm = if hour >= 12 then "pm" else "am"
    hour12 = if hour % 12 then hour % 12 else 12
    @set 'last_updated', "#{hour12}:#{minutes} #{ampm}"

