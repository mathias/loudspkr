require 'octokit'
require 'dotenv'

Dotenv.load

def raise_alarm
  puts "\e[33mFor the Github widget to work, you need to put in your Github Token and a list of repos in the .env file.\e[0m"
end

@github_token = ENV['GITHUB_PRIVATE_TOKEN']

begin
  @repos = ENV['GITHUB_REPOS'].split(',')
  @orgs = ENV['GITHUB_ORGS'].split(',')
rescue
  raise_alarm
end

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '5m', :first_in => 0 do |job|
  raise_alarm unless @github_token

  client = Octokit::Client.new :access_token => @github_token

  repos = @repos.map do |repo_name|
    begin
      repo = client.repository(repo_name)
      pull_requests =  client.pull_requests(repo_name, options: {state: 'open'}).count

      {
        name: repo.full_name,
        watchers: repo.watchers,
        issues: repo.open_issues_count,
        pull_requests: pull_requests,
        url: repo.homepage
      }
    rescue
      # handle repo not found safely
      {
        name: repo_name,
        status: "not found"
      }
    end
  end

  send_event('github_repos', { repos: repos })
end
