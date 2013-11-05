require 'net/http'
require 'uri'
require 'nokogiri'
require 'htmlentities'

news_feeds = {
  "last-bendyworks-blog" => "http://bendyworks.com/geekville.atom",
}

Decoder = HTMLEntities.new

class LastPost
  def initialize(widget_id, feed)
    @widget_id = widget_id
    # pick apart feed into domain and path
    uri = URI.parse(feed)
    @path = uri.path
    @http = Net::HTTP.new(uri.host)
  end

  def widget_id
    @widget_id
  end

  def last_post
    response = @http.request(Net::HTTP::Get.new(@path))
    doc = Nokogiri::XML(response.body).children.first

    last_entry = doc.css('entry').first

    published_date = last_entry.css('published').text
    title = clean_html( last_entry.css('title').text )
    author = clean_html( last_entry.css('author').text )

    {title: title, author: author, published_date: published_date }
  end

  def clean_html(html)
    html = html.gsub(/<\/?[^>]*>/, "")
    html = Decoder.decode( html )
    return html
  end

end

@feeds = []
news_feeds.each do |widget_id, feed|
  begin
    @feeds.push(LastPost.new(widget_id, feed))
  rescue Exception => e
    puts e.to_s
  end
end

SCHEDULER.every '60m', :first_in => 0 do |job|
  @feeds.each do |feed|
    send_event(feed.widget_id, feed.last_post)
  end
end
