class Dashing.Likes extends Dashing.Widget
  @accessor 'fb_likes', Dashing.AnimatedValue
  @accessor 'foursq_checkins', Dashing.AnimatedValue

  ready: ->

  onData: (data) ->
