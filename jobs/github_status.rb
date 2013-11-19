require 'faraday'
require 'json'

github_api = 'https://status.github.com/api/last-message.json'

SCHEDULER.every '1m', :first_in => 0 do
  github_status = JSON.parse(Faraday.get(github_api).body)
  send_event('github_status', github_status)
end
