json.array!(@ad_urls) do |ad_url|
  json.extract! ad_url, :id, :link, :position, :is_ad
  json.url ad_url_url(ad_url, format: :json)
end
