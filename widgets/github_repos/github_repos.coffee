class Dashing.GithubRepos extends Dashing.Widget
  ready: ->
    @containerEl = $(@node).find('.repo-container')
    @currentIndex = 0
    @nextRepo()
    @startCarousel()

  onData: (data) ->
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

        pull_requests = parseInt(repo.pull_requests)
        issues = parseInt(repo.issues)

        if pull_requests > 0
          $(@node).css('background-color', '#DB000F') # RED
          alert = "ALL HANDS ON DECK. OUTSTANDING PULL REQUESTS."
        else if issues > 0
          $(@node).css('background-color', '#E3CA09') # YELLOW
          alert = "YELLOW ALERT. ISSUES DETECTED."
        else
          $(@node).css('background-color', '#0BE84E') # GREEN
          alert = "ALL SYSTEMS GO."

        $(@node).find('.moreinfo').text(alert)
        @containerEl.fadeIn()

