require "sinatra"
require "sinatra/reloader"
require "json"
require "httparty"

get("/") do
  @news = fetch_news #_file
  @models = fetch_models #_file
  @tips = fetch_tips #_file
  @events = fetch_events #_file

  erb(:index)
end

private

def fetch_news_file
  news_file = File.read('./fetch_news.json')
  file_data = JSON.parse(news_file)
  news_data = file_data["newsResults"]
  news_data
end

def fetch_models_file
  models_file = File.read('./fetch_models.json')
  file_data = JSON.parse(models_file)
  models_data = file_data["organicResults"]
  models_data
end

def fetch_tips_file
  tips_file = File.read('./fetch_tips.json')
  file_data = JSON.parse(tips_file)
  tips_data = file_data["organicResults"]
  tips_data
end

def fetch_events_file
events_file = File.read('./fetch_events.json')
file_data = JSON.parse(events_file)
events_data = file_data["eventsResults"]
events_data
end

def fetch_news
  api_key = ENV.fetch("SCRAPEIT_API_KEY")
  url = "https://api.scrape-it.cloud/scrape/google/serp?q=3D+Printing&tbm=nws&deviceType=desktop&num=42&hl=en"
  headers = { "x-api-key" => api_key }

  response = HTTParty.get(url, headers: headers)

  if response.code == 200
    data = JSON.parse(response.body)
    news_data = data["newsResults"]
  else
    puts "Error fetching news: #{response.code} - #{response.message}, using cached content instead."
    news_data = fetch_news_file
  end
  news_data
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
    puts "Error fetching models: #{response.code} - #{response.message}, using cached content instead."
    models_data = fetch_models_file
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
    tips_data = data["organicResults"]
  else
    puts "Error fetching tips and tricks: #{response.code} - #{response.message}, using cached content instead."
    tips_data = fetch_tips_file
  end
  tips_data
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
    puts "Error fetching events: #{response.code} - #{response.message}, using cached content instead."
    events_data = fetch_events_file
  end
  events_data
end
