require 'net/http'
require 'uri'
require 'json'
require 'faraday'

@uri = URI.parse('http://api.bcycle.com/services/mobile.svc/ListKiosks')

SCHEDULER.every '5m', :first_in => 0 do |job|
  response = Faraday.get @uri
  json = JSON.parse(response.body)

  stations = json['d']['list']

  stations = stations.map do |row|
    row = {
      :id => row['Id'],
      :name => row['Name'],
      :status => row['Status'],
      :hours => row['HoursOfOperation'],
      :bikes_available => row['BikesAvailable'],
      :trikes_available => row['TrikesAvailable'],
      :docks_available => row['DocksAvailable'],
      :total_docks => row['TotalDocks']
    }
  end

  stations.each { |station|
    event_name = 'bcycle_'+station[:id].to_s
    send_event(event_name, station)
  }

end
