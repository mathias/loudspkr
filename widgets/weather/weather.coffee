class Dashing.Weather extends Dashing.Widget
  ready: ->
    @currentIndex = 0
    @cards = [$('#current'), $('#today'), $('#week')]
    _.each @cards, (el) ->
      el.hide()

    @nextCard()
    @startCarousel()

  onData: (data) ->
    @currentIndex = 0

    @currentBg(@get('current.temperature'))
    @getWindDirection(@get('current.wind_bearing'))
    @todayBg(@get('today.high'), @get('today.low'))
    @thisWeekBg(@get('upcoming_week'))
    @unpackWeek(@get('upcoming_week'))
    @getTime()

  startCarousel: ->
    interval = $(@node).attr('data-interval')
    interval = "10" if not interval
    setInterval(@nextCard, parseInt( interval ) * 1000)

  nextCard: =>
    @cards[@currentIndex].fadeOut =>
      @currentIndex = (@currentIndex + 1) % @cards.length
      @cards[@currentIndex].fadeIn()

  @accessor 'current_icon', ->
    getIcon(@get('current.icon'))

  @accessor 'day_icon', ->
    getIcon(@get('today.icon'))

  currentBg: (temp) ->
    @set 'right_now_bg', WeatherShared.getBackground(temp)

  todayBg: (high, low) ->
    averageRaw = (high + low) / 2
    average = Math.round(averageRaw)
    @set 'today_bg', WeatherShared.getBackground(average)

  thisWeekBg: (weekRange) ->
    averages = []
    for day in weekRange
      average = Math.round((day.max_temp + day.min_temp) / 2)
      averages.push average
    sum = 0
    averages.forEach (a) -> sum += a
    weekAverage = Math.round(sum / 7)
    @set 'this_week_bg', WeatherShared.getBackground(weekAverage)

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
  getTime: (now = new Date()) ->
    hour = now.getHours()
    minutes = now.getMinutes()
    minutes = if minutes < 10 then "0#{minutes}" else minutes
    ampm = if hour >= 12 then "pm" else "am"
    hour12 = if hour % 12 then hour % 12 else 12
    @set 'last_updated', "#{hour12}:#{minutes} #{ampm}"

  getWindDirection: (windBearing) ->
    @set 'wind_bearing', getWindDirection(windBearing)


