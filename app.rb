require "sinatra"
require "sinatra/reloader"
require "httparty"
require 'open-uri'
def view(template); erb template.to_sym; end

get "/" do

### Get the weather @ the Wilson L stop
    lat = 41.964680
    long = -87.657703

    units = "imperial"
    key = "09a8f69b34285d6ecffc135310e46280"

    # construct the URL to get the API data (https://openweathermap.org/api/one-call-api)
    url = "https://api.openweathermap.org/data/2.5/onecall?lat=#{lat}&lon=#{long}&units=#{units}&appid=#{key}"

    @forecast = HTTParty.get(url).parsed_response.to_hash
 

    @currenttemp = "#{@forecast ["current"]["temp"]}"
    @currentdesc = "#{@forecast["current"]["weather"][0]["description"]}"

    day_number = 1

    @extended = [] 
        for @day in @forecast ["daily"]
            @extended << "On day #{day_number}, expect a high of #{@day["temp"]["max"]} and a low of #{@day["temp"]["min"]} with #{@day["weather"][0]["description"]}"
            day_number = day_number + 1
        end

###Get the headlines
    
    url = 'http://newsapi.org/v2/top-headlines?'\
        'country=us&'\
        'apiKey=e20f38f7bca24084bf5599e4c818f2f6'
    req = open(url)
    response_body = req.read
    puts response_body
    
    article_number = 0

    @news = HTTParty.get(url).parsed_response.to_hash

    @headline = []
        for @article in @news ["articles"]
            @headline << 
                "<div>" "<p> #{@article["title"]} | <a href=#{@article["url"]}> Link </a> </p>" "</div>"
            article_number = article_number + 1
        end

    view "news"
end