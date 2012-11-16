require 'appengine-apis/logger'
require 'json'
require 'lib/smslacquey/weathermatcher'

module SmsLacquey
  
  class WeatherSteward
    
    def initialize
      @logger = AppEngine::Logger.new
      @forcastsubrules = [['with a chance of a', 'chance'],
                          ["thunderstorm", "t-storm"],
                          [" and a chance of ", "/"],
                          [" in the morning", ""],
                          ["High of ", "H "],
                          ["Low of", "L"],
                          ["with", "w"],
                          [" in the evening", ""],
                          [" and ", "/"],
                          ["ly", ""]]
      
    end
    
    def match(msg_body)
      
      weather_params = WeatherMatcher.new.matches(msg_body)

      if !weather_params.nil? then
        default_zipcode = '48103'
        default_zipcode = weather_params.zipcode if !weather_params.zipcode.nil?
        url = "http://api.wunderground.com/api/b057e00591a22267/conditions/hourly/forecast/q/#{default_zipcode}.json"
        url_fetch = AppEngine::URLFetch.fetch(url, {:deadline => 60})  
        json_doc = JSON.parse(url_fetch.body)
        
        return hourly_forcast(json_doc, weather_params) if weather_params.hourly
        
        return current_forcast(json_doc)
      end
      
      return ""
      
    end
    
    def hourly_forcast(json_doc, weather_params)
      hour_forcasts = json_doc["hourly_forecast"]
      if weather_params.starting_hour.nil? then
        
        response = ""

        is_first = true
        hour_forcasts.each do |forcast|
          rendered = render_single_hour_forcast_string(forcast, is_first)
          break if (rendered + response).length > 160
          response = response + rendered
          is_first = false

          is_first = true if forcast["FCTTIME"]["hour"] == "11" || forcast["FCTTIME"]["hour"] == "23"             
        end
        
        return response
      end
      
      return "hourly forcast starting at: #{weather_params.starting_hour}"
    end
    
    def render_single_hour_forcast_string(forcast, is_first)
      response = ""
      hour = forcast["FCTTIME"]["hour"]
      
      hourVal = Integer(hour)
      suffix = "am"
      if hourVal > 12 then
        suffix = "pm"
        hourVal = hourVal - 12
      elsif hourVal < 1 then
        suffix = "am"
        hourVal = hourVal + 12
      end
      
      if is_first then
        response = "#{hourVal}#{suffix}"
      else
        response = "#{hourVal}"
      end
      
      response = response + " #{forcast['temp']['english']}F/#{forcast['humidity']}% (~#{forcast['feelslike']['english']}), #{forcast['condition']}. "
    end
    
    def current_forcast(json_doc)
      temp_f = Float(json_doc["current_observation"]["temp_f"]).round
      response = "#{temp_f}F "
      
      feels_like_f = Float(json_doc["current_observation"]["feelslike_f"]).round
      response = response + "(~#{feels_like_f}). "
      
      forcasts = json_doc["forecast"]["txt_forecast"]["forecastday"]
      morning_forcast_sentences = forcasts[0]["fcttext"].split('.')
      morning_forcast = morning_forcast_sentences[0] + '. ' + morning_forcast_sentences[1] + '. '
      response = response + 'M: ' + morning_forcast
      
      evening_forcast_sentences = forcasts[1]["fcttext"].split('.')
      evening_forcast = evening_forcast_sentences[0] + '. ' + evening_forcast_sentences[1]
      response = response + 'E: ' + evening_forcast
      
      if response.length > 160 then # 160 is the max character limit for sending back sms via Twilio
        @logger.info "The response is too long: #{response}"
        @forcastsubrules.each { |rule| response.gsub!(rule[0], rule[1]) }
        @logger.info "The response has been shortened to: #{response}"
      end
      
      response
      
    end
    
    
  end
end