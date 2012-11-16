require 'appengine-apis/logger'
require 'json'

module SmsLacquey
  
  class WeatherParams
    def initialize(hourly, starting_hour, zipcode)
      @hourly = hourly
      @starting_hour = starting_hour
      @zipcode = zipcode
    end
    
    def hourly
      @hourly
    end
    
    def starting_hour
      @starting_hour
    end
    
    def zipcode
      @zipcode
    end
    
  end
  
  class WeatherMatcher
    
    def initialize
      @logger = AppEngine::Logger.new
    end
    
    def matches(msg_body)
      matches = false
      hourly = false
      starting_hour = nil
      zipcode = nil
      
      msg_words = msg_body.downcase.scan(/[\w']+/)
      index = msg_words.index("weather")
      matches = true if !index.nil?
      
      index = msg_words.index("w")
      matches = true if !index.nil?
      
      if matches then
        index = msg_words.index("hourly")
        hourly = true if !index.nil?
        
        numbers = msg_words.find_all {|word| !!(word =~ /^[-+]?[0-9]+$/) } # look for numbers in the words
        if !numbers.nil? then
          numbers.each do |number|
            if number.length == 2 then
              starting_hour = number
            elsif number.length == 5 then
              zipcode = number
            end
          end
        end
          
      end
      
      if matches then
        return WeatherParams.new(hourly, starting_hour, zipcode)
      end
      
      return nil
    
    end
    
  end
  
end