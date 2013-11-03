class Dashing.WeatherWeek extends Dashing.Widget
  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
    # Handle incoming data
    @thisWeekBg(@get('upcoming_week'))
    @unpackWeek(@get('upcoming_week'))

    # flash the html node of this widget each time data comes in
    $(@node).fadeOut().fadeIn()

  thisWeekBg: (weekRange) ->
    averages = []
    for day in weekRange
      average = Math.round((day.max_temp + day.min_temp) / 2)
      averages.push average
    sum = 0
    averages.forEach (a) -> sum += a
    weekAverage = Math.round(sum / 7)

    @set 'this_week_bg', "widget widget-weather-week " + WeatherShared.getBackground(weekAverage)

  unpackWeek: (thisWeek) ->
    # get max temp, min temp, icon for the next seven days
    days = []
    for day in thisWeek
      dayObj = {
        time: day['time'],
        min_temp: "#{day['min_temp']}&deg;",
        max_temp: "#{day['max_temp']}&deg;",
        icon: getIcon(day['icon'])
      }
      days.push dayObj
    @set 'this_week', days
