require "sinatra"
require "sinatra/reloader"
require "json"
require "httparty"

get("/") do
  @news = fetch_news
  @models = fetch_models
  @tips = fetch_tips
  @events = fetch_events

  erb(:index)
end

private

def fetch_news
  api_key = ENV.fetch("SCRAPEIT_API_KEY")
  url = "https://api.scrape-it.cloud/scrape/google/serp?q=3D+Printing&tbm=nws&deviceType=desktop&num=42&hl=en"
  headers = { "x-api-key" => api_key }

  response = HTTParty.get(url, headers: headers)

  if response.code == 200
    data = JSON.parse(response.body)
    news_articles = data["newsResults"]
  else
    puts "Error fetching news: #{response.code} - #{response.message}"
    news_articles = []
  end
  news_articles
end

def fetch_models
  api_key = ENV.fetch("SCRAPEIT_API_KEY")
  url = "https://api.scrape-it.cloud/scrape/google/serp?q=3d+printing+models+free&deviceType=desktop&hl=en"
  headers = { "x-api-key" => api_key }

  response = HTTParty.get(url, headers: headers)

  if response.code == 200
    data = JSON.parse(response.body)
    models_data = data["organicResults"]
  else
    puts "Error fetching models: #{response.code} - #{response.message}"
    models_data = []
  end
  models_data
end

def fetch_tips
  api_key = ENV.fetch("SCRAPEIT_API_KEY")
  url = "https://api.scrape-it.cloud/scrape/google/serp?q=3D+printing+Tips+and+Tricks&deviceType=desktop&hl=en"
  headers = { "x-api-key" => api_key }

  response = HTTParty.get(url, headers: headers)

  if response.code == 200
    data = JSON.parse(response.body)
    tips_tricks_data = data["organicResults"]
  else
    puts "Error fetching tips and tricks: #{response.code} - #{response.message}"
    tips_tricks_data = []
  end
  tips_tricks_data
end

def fetch_events
  api_key = ENV.fetch("SCRAPEIT_API_KEY")
  url = "https://api.scrape-it.cloud/scrape/google/events?q=3D+Printing+Events+in+Chicago&location=Chicago%2CIllinois%2CUnited+States&hl=en&htichips=date%3Aweek%3A+This+Week%27s+Events%2Cdate%3Aweekend%3A+This+Weekend%27s+Events%2Cevent_type%3AVirtual-Event%2Cdate%3Aweek"
  headers = { "x-api-key" => api_key }

  response = HTTParty.get(url, headers: headers)

  if response.code == 200
    data = JSON.parse(response.body)
    events_data = data["eventsResults"]
  else
    puts "Error fetching events: #{response.code} - #{response.message}"
    events_data = []
  end
  events_data
end
