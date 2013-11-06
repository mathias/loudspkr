class Dashing.DaysSinceLastPost extends Dashing.Widget
  ready: ->
    setInterval(@setDaysAgo, 500)
    # This is fired when the widget is done being rendered

  onData: (data) ->
    console.log data
    @setDaysAgo(data.updated_at)
    @updateBg(data.updated_at)

  setDaysAgo: (updatedAt) ->
    if updatedAt
      daysAgo = moment(updatedAt).fromNow()
      @set('daysAgo', daysAgo)

  updateBg: (updatedAt) ->
    console.log updatedAt
    difference_in_days = moment().diff(updatedAt, 'days')
    console.log difference_in_days

    if difference_in_days >= 30
      @set 'overdue_bg', 'overdue'
    else
      @set 'overdue_bg', 'normal'

