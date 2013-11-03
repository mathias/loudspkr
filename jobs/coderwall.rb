require 'net/http'
require 'json'

require 'dotenv'
Dotenv.load

SCHEDULER.every '30m', :first_in => '5s' do |job|
  uri = URI.parse("https://coderwall.com/team/#{ENV['CODERWALL_TEAM']}.json")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(request)
  status = JSON.parse(response.body)

  name = status['name']
  rank = status['rank']
  team_size = status['size']
  moreinfo = name + ", currently at " + team_size.to_s + " members. (Lower is better.)"

  send_event("coderwall", { title: "Coderwall Rank", current: rank, moreinfo: moreinfo })
end
