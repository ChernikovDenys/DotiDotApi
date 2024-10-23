require 'nokogiri'
require 'open-uri'

class ScraperService
  CACHE_EXPIRATION = 5.minutes

  def scrape(url, fields)
    html = fetch_cached_html(url)
    puts html
    document = Nokogiri::HTML(html)
    result = {}

    fields.each do |field, selector|
      if field == "meta"
        result[field] = extract_meta_tags(document, selector)
      else
        result[field] = document.css(selector)&.text&.strip || "Not found"
      end
    end

    result
  end

  private

  def fetch_cached_html(url)
    Rails.cache.fetch(url, expires_in: CACHE_EXPIRATION) do
      open_url(url).to_s
    end
  end

  def open_url(url)
    begin
      content = URI.open(url, 
        "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:89.0) Gecko/20100101 Firefox/89.0",
        "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
        "Accept-Language" => "en-US,en;q=0.5",
        "Referer" => "https://www.google.com"
      )

      content_string = content.read
      puts content_string
      content_string
    rescue OpenURI::HTTPError => e
      raise "Error fetching the URL: #{e.message}"
    rescue => e
      raise "Error: #{e.message}"
    end
  end  

  def extract_meta_tags(document, meta_names)
    meta_info = {}
    meta_names.each do |meta_name|
      meta_tag = document.at("meta[id='metaDescription']") || document.at("meta[name='#{meta_name}']") || document.at("meta[property='#{meta_name}']")
      meta_info[meta_name] = meta_tag ? meta_tag[:content] : "Not found"
    end
    meta_info
  end
  
end
