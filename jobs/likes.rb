require 'foursquare2'
require 'faraday'
require 'json'

require 'dotenv'
Dotenv.load

venue_id = ENV['FOURSQUARE_VENUE_ID']
oauth_token = ENV['FOURSQUARE_CONSUMER_SECRET']
graph_uri = ENV['FACEBOOK_PAGE_URI']

raise "Need Facebook and Foursquare keys in ENV!" unless venue_id && oauth_token && graph_uri

client = Foursquare2::Client.new(:oauth_token => oauth_token)

SCHEDULER.every '5m', :first_in => 0 do
  response = Faraday.get(graph_uri)

  fb_data = JSON.parse(response.body)
  fb_likes = fb_data['likes']
  fb_name = fb_data['name']

  #Get foursquare data
  foursq_data = client.venue(venue_id)
  foursq_checkins = foursq_data['stats']['checkinsCount']
  foursq_mayor = [foursq_data['mayor']['user']['firstName'], foursq_data['mayor']['user']['lastName']].join ' '

  likes = {
    fb_name: fb_name || '',
    fb_likes: fb_likes || 0,
    foursq_checkins: foursq_checkins || 0,
    foursq_mayor: foursq_mayor || ''
  }

  send_event('likes', likes)
end
