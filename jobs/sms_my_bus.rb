require 'sms_my_bus'
require 'dotenv'
Dotenv.load

SmsMyBus.key = ENV['SMS_MY_BUS_KEY']

file_path = File.join(File.dirname(__FILE__), '..', 'config', 'buses.json')

begin
 config = JSON.parse(File.read(file_path))
rescue Errno::ENOENT => e
  puts "You must create a `config/buses.json` file. See `config/buses.json.example` for keys"
  exit 0
rescue JSON::ParserError => e
  puts "You have errors in your JSON in `config/buses.json`"
  exit 0
end

stops = config['stopIDs']
routes = config['routeIDs']
destinations = config['destinations']

SCHEDULER.every '1m', :first_in => '5s' do |job|

  arrivals_by_stop = stops.map do |stopID|
    stop_name = SmsMyBus.make_api_request('getstoplocation', { 'stopID' => stopID })["intersection"]

    arrivals = []
    arrivals += SmsMyBus::Schedules.get_arrivals(stopID)['stop']['route']

    arrivals.select! { |arrival| routes.include?(arrival['routeID']) && destinations.include?(arrival['destination']) }

    arrivals.sort_by! { |a| a['minutes'].to_i }

    {label: stop_name, arrivals: arrivals}
  end

  send_event('sms_my_bus', { stops: arrivals_by_stop })
end
