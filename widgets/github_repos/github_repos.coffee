class Dashing.GithubRepos extends Dashing.Widget
  ready: ->
    @containerEl = $(@node).find('.repo-container')
    @currentIndex = 0
    @nextRepo()
    @startCarousel()

  onData: (data) ->
    @currentIndex = 0
    @set('repo', @get('repos')[@currentIndex])

  startCarousel: ->
    interval = $(@node).attr('data-interval')
    interval = "30" if not interval
    setInterval(@nextRepo, parseInt( interval ) * 1000)

  nextRepo: =>
    repos = @get('repos')

    if repos?
      @containerEl.fadeOut =>
        @currentIndex = (@currentIndex + 1) % repos.length
        repo = repos[@currentIndex]
        @set('repo', repo)

        if repo.pull_requests.length > 0
          $(@node).css('background-color', '#A6C700')
        else
          $(@node).css('background-color', '#DB000F')

        @containerEl.fadeIn()

