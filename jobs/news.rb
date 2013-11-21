require 'faraday'
require 'uri'
require 'nokogiri'
require 'htmlentities'

news_feeds = {
  "bendyworks-blog" => "http://bendyworks.com/geekville.atom",
}

Decoder = HTMLEntities.new

class News
  def initialize(widget_id, feed)
    @widget_id = widget_id
    @uri = URI.parse(feed)
  end

  def widget_id
    @widget_id
  end

  def latest_headlines
    response = Faraday.get(@uri)
    doc = Nokogiri::XML(response.body).children.first

    news_headlines = [];
    doc.css('entry').each do |news_item|
      title = clean_html(news_item.css('title').text)
      description = clean_html(news_item.css('content').text)
      author = clean_html(news_item.css('author').text)
      published_at = clean_html(news_item.css('published').text)
      updated_at = clean_html(news_item.css('updated').children.first.text)

      news_headlines.push({
        title: title.to_s,
        description: description.to_s,
        author: author.to_s,
        published_at: published_at.to_s,
        updated_at: updated_at.to_s,
      })
    end

    news_headlines
  end

  def clean_html(html)
    html = html.gsub(/<\/?[^>]*>/, "")
    html = Decoder.decode( html )
    return html
  end

  def last_blog_post
    latest_headlines.first || ''
  end

end

@news = []
news_feeds.each do |widget_id, feed|
  begin
    @news.push(News.new(widget_id, feed))
  rescue Exception => e
    puts e.to_s
  end
end
@news.compact!

SCHEDULER.every '5m', :first_in => 0 do |job|
  @news.each do |news|
    headlines = news.latest_headlines()
    send_event(news.widget_id, { :headlines => headlines || [] })
    send_event('days_since_last_post', news.last_blog_post)
  end

end
