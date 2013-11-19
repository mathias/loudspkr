require 'openid/store/filesystem'
require 'omniauth/strategies/google_apps'
require 'dashing'

require 'dotenv'
Dotenv.load

configure do
  set :auth_token, ENV['AUTH_TOKEN']

  helpers do
    def protected!
      redirect '/auth/g' unless session[:user_id]
    end
  end

  fail "Must provide Rack::Session::Cookie in ENV!"  unless ENV['RACK_SECRET']
  use Rack::Session::Cookie, secret: ENV['RACK_SECRET']
  use OmniAuth::Builder do
    provider :google_apps, :store => OpenID::Store::Filesystem.new('./tmp'), :name => 'g', :domain => ENV['GOOGLE_DOMAIN']
  end

  post '/auth/g/callback' do
    if auth = request.env['omniauth.auth']
      session[:user_id] = auth['info']['email']
      redirect '/'
    else
      redirect '/auth/failure'
    end
  end

  get '/auth/failure' do
    'Nope.'
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application
