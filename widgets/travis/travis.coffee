class Dashing.Travis extends Dashing.Widget
  ready: ->
    @containerEl = $(@node).find('.repo-container')
    @currentIndex = 0
    @nextRepo()
    @startCarousel()

  onData: (data) ->
    console.log(data)
    @currentIndex = 0
    @repos = @get('repos')
    @set('repo', @get('repos')[@currentIndex])

  startCarousel: ->
    interval = $(@node).attr('data-interval')
    interval = "10" if not interval
    setInterval(_.bind(@nextRepo, this), parseInt(interval) * 1000)

  nextRepo: ->
    repos = @get('repos')

    if repos?
      @containerEl.fadeOut =>
        @currentIndex = (@currentIndex + 1) % repos.length
        repo = repos[@currentIndex]

        @set('repo', repo)

        status = repo.state

        $(@node).removeClass('errored failed passed started')
        $(@node).addClass(status)


        #$(@node).find('.moreinfo').text(alert)
        @containerEl.fadeIn()

