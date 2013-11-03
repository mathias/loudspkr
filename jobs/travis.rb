require 'travis'
require 'travis/pro'

require 'dotenv'
Dotenv.load

def update_builds(repository)
  builds = []
  repo = nil

  github_user = ENV['TRAVIS_GITHUB_USER']
  repo_path = github_user + "/" + repository

  if ENV['TRAVIS_TYPE'] == "pro"
    Travis::Pro.access_token = ENV["TRAVIS_AUTH_TOKEN"]
    repo = Travis::Pro::Repository.find(repo_path)
  else  # Standard namespace
    Travis.access_token = ENV["TRAVIS_AUTH_TOKEN"]
    repo = Travis::Repository.find(repo_path)
  end

  build = repo.last_build
  build_info = {
    label: "Build #{build.number}",
    value: "[#{build.branch_info}], #{build.state} in #{build.duration}s",
    state: build.state
  }
  builds << build_info

  builds
end

repos = ENV['TRAVIS_REPOS'].split(',')

SCHEDULER.every('5m', first_in: '1s') {
  if repos.empty?
    puts "No repositories for travis configured."
  else
    repos.each do |repo|
      send_event("ci_travis_#{repo}", { items: update_builds(repo) })
    end
  end
}
