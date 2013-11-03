require 'date'
require 'net/https'
require 'json'

# Forecast API Key from https://developer.forecast.io
forecast_api_key = ENV['FORECAST_API_KEY'] 

# Latitude, Longitude for location
forecast_location_lat = ENV['LATITUDE'] 
forecast_location_long = ENV['LONGITUDE'] 

# Unit Format
forecast_units = "ca" # like "si", except windSpeed is in kph

def time_to_str(time_obj)
  """ format: 5 pm """
  return Time.at(time_obj).strftime "%-l %P"
end

def time_to_str_minutes(time_obj)
  """ format: 5:38 pm """
  return Time.at(time_obj).strftime "%-l:%M %P"
end
  
def day_to_str(time_obj)
  """ format: Sun """
  return Time.at(time_obj).strftime "%a"
end
  
SCHEDULER.every '5m', :first_in => 0 do |job|
  http = Net::HTTP.new("api.forecast.io", 443)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  response = http.request(Net::HTTP::Get.new("/forecast/#{forecast_api_key}/#{forecast_location_lat},#{forecast_location_long}?units=#{forecast_units}"))
  forecast = JSON.parse(response.body)  

  currently = forecast["currently"]
  current = {
    temperature: currently["temperature"].round,
    summary: currently["summary"],
    humidity: "#{(currently["humidity"] * 100).round}&#37;",
    wind_speed: currently["windSpeed"].round,
    wind_bearing: currently["windSpeed"].round == 0 ? 0 : currently["windBearing"],
    icon: currently["icon"]
  }

  daily = forecast["daily"]["data"][0]
  today = {
    summary: forecast["hourly"]["summary"],
    high: daily["temperatureMax"].round,
    low: daily["temperatureMin"].round,
    sunrise: time_to_str_minutes(daily["sunriseTime"]),
    sunset: time_to_str_minutes(daily["sunsetTime"]),
    icon: daily["icon"]
  }

  this_week = []
  for day in (1..7) 
    day = forecast["daily"]["data"][day]
    this_day = {
      max_temp: day["temperatureMax"].round,
      min_temp: day["temperatureMin"].round,
      time: day_to_str(day["time"]),
      icon: day["icon"]
    }
    this_week.push(this_day)
  end

  send_event('verbinski', { 
    current: current,
    today: today,
    upcoming_week: this_week,
  })
end

