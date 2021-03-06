require 'date'
require 'faraday'
require 'json'

require 'dotenv'
Dotenv.load

# Forecast API Key from https://developer.forecast.io
forecast_api_key = ENV['FORECAST_API_KEY']

# Latitude, Longitude for location
forecast_location_lat = ENV['LATITUDE']
forecast_location_long = ENV['LONGITUDE']

# Unit Format
#forecast_units = "ca" # like "si", except windSpeed is in kph
forecast_units = "auto"

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

SCHEDULER.every '10m', :first_in => 0 do |job|
  uri = "https://api.forecast.io/" +
    "forecast/#{forecast_api_key}/#{forecast_location_lat},#{forecast_location_long}?units=#{forecast_units}"

  response = Faraday.get(uri)
  forecast = JSON.parse(response.body)

  raise "Forecast.io: " + forecast["error"] if forecast.has_key?("error")

  currently = forecast["currently"] || {}
  current = {
    temperature: currently.fetch("temperature", 0).round,
    summary: currently["summary"],
    humidity: "#{(currently.fetch("humidity", 0) * 100).round}&#37;",
    wind_speed: currently.fetch("windSpeed", 0).round,
    wind_bearing: currently.fetch("windSpeed", 0).round == 0 ? 0 : currently["windBearing"],
    icon: currently["icon"]
  }

  daily = forecast["daily"]["data"][0] || {}
  today = {
    summary: forecast["hourly"]["summary"],
    high: daily.fetch("temperatureMax", 0).round,
    low: daily.fetch("temperatureMin", 0).round,
    sunrise: time_to_str_minutes(daily["sunriseTime"]),
    sunset: time_to_str_minutes(daily["sunsetTime"]),
    icon: daily["icon"]
  }

  this_week = []
  for day in (1..7)
    day = forecast["daily"]["data"][day] || {}
    this_day = {
      max_temp: day.fetch("temperatureMax", 0).round,
      min_temp: day.fetch("temperatureMin", 0).round,
      time: day_to_str(day["time"]),
      icon: day["icon"]
    }
    this_week.push(this_day)
  end

  send_event('weather', {
    current: current,
    today: today,
    upcoming_week: this_week
  })
end

