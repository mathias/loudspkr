require 'travis'

require 'dotenv'
Dotenv.load

@travis_token = ENV['TRAVIS_AUTH_TOKEN']
@repos = ENV['TRAVIS_REPOS'].split(',')

Travis.access_token = @travis_token

def raise_alarm
  puts "\e[33mFor the new Travis widget to work, you need to put in your Travis API Token and a list of repos in the .env file.\e[0m"
end

def update_builds(repo_path)
  builds = []
  repo = Travis::Repository.find(repo_path)

  build = repo.last_build

  {
    name: repo_path,
    label: "Build #{build.number}",
    value: "[#{build.branch_info}], #{build.state} in #{build.duration}s",
    state: build.state
  }
end

SCHEDULER.every '5m', :first_in => 0 do |job|
  raise_alarm if @travis_token.nil? || @repos.nil?

  repos = @repos.map { |repo_path| update_builds(repo_path) }

  send_event('travis_ci', { repos: repos })
end
