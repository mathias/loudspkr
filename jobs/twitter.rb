require 'twitter'

require 'dotenv'
Dotenv.load

#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
Twitter.configure do |config|
  config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  config.oauth_token = ENV['TWITTER_OAUTH_TOKEN']
  config.oauth_token_secret = ENV['TWITTER_OAUTH_SECRET']
end

search_term = URI::encode('@bendyworks')

SCHEDULER.every '10m', :first_in => 0 do |job|
  begin
    tweets = Twitter.search("#{search_term}").results

    if tweets
      tweets.map! do |tweet|
        {
          name: tweet.user.name,
          screen_name: tweet.user.screen_name,
          body: tweet.text,
          avatar: tweet.user.profile_image_url_https,
          created_at: tweet.created_at
        }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end
