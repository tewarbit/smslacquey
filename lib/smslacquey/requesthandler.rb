require 'lib/smslacquey/movietimes/movietimes'
require 'lib/smslacquey/movietimes/movietimessteward'
require 'lib/smslacquey/weathersteward'

module SmsLacquey
  
  class RequestHandler
    
    def initialize()
      @stewards = [ MovieTimesSteward.new, WeatherSteward.new ]
    end
    
    def handle_request(from_number, msg_body)
      
      @stewards.each do | steward |
        matches = steward.match(msg_body)
        return matches if !matches.empty? 
      end
    
      "No matching steward found for request"  
    end
    
  end
  
end