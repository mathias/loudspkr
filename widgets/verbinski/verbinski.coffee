class Dashing.Verbinski extends Dashing.Widget

  @accessor 'current_icon', ->
    getIcon(@get('current.icon'))

  @accessor 'day_icon', ->
    getIcon(@get('today.icon'))

  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
    # Handle incoming data
    @currentBg(@get('current.temperature'))
    @getWindDirection(@get('current.wind_bearing'))
    @todayBg(@get('today.high'), @get('today.low'))
    @thisWeekBg(@get('upcoming_week'))
    @unpackWeek(@get('upcoming_week'))
    @getTime()

    # flash the html node of this widget each time data comes in
    $(@node).fadeOut().fadeIn()

  currentBg: (temp) ->
    @set 'right_now', @getBackground(temp)

  getWindDirection: (windBearing) ->
    @set 'wind_bearing', getWindDirection(windBearing)

  todayBg: (high, low) ->
    averageRaw = (high + low) / 2
    average = Math.round(averageRaw)
    @set 'today_bg', @getBackground(average)

  thisWeekBg: (weekRange) ->
    averages = []
    for day in weekRange
      average = Math.round((day.max_temp + day.min_temp) / 2)
      averages.push average
    sum = 0
    averages.forEach (a) -> sum += a
    weekAverage = Math.round(sum / 7)
    @set 'this_week_bg', @getBackground(weekAverage)

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

  getBackground: (temp) ->
    range =
      0: -20
      1: [-19..-11]
      2: [-10..-1]
      3: [0..4]
      4: [5..9]
      5: [10..14]
      6: [15..19]
      7: [20..24]
      8: 25

    weather = "#4b4b4b"
    switch
      when temp <= range[0] then weather = 'cold5'
      when temp in range[1] then weather = 'cold4'
      when temp in range[2] then weather = 'cold3'
      when temp in range[3] then weather = 'cold2'
      when temp in range[4] then weather = 'cold1'
      when temp in range[5] then weather = 'cool2'
      when temp in range[6] then weather = 'cool1'
      when temp in range[7] then weather = 'warm'
      when temp >= range[8] then weather = 'hot'
    weather

  getTime: (now = new Date()) ->
    hour = now.getHours()
    minutes = now.getMinutes()
    minutes = if minutes < 10 then "0#{minutes}" else minutes
    ampm = if hour >= 12 then "pm" else "am"
    hour12 = if hour % 12 then hour % 12 else 12
    @set 'last_updated', "#{hour12}:#{minutes} #{ampm}"

