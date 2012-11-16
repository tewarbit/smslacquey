require 'singleton'

module SmsLacquey

  class Config
    include Singleton
  
    def initialize()
      @weather_api_key = '<wunderground api key>'
      @twilio_account_sid = '<twilio account sid>'
      @twilio_auth_token = '<twilio auth token>'
      @twilio_number = '<twilio number>'
      @dev_mode = true
    end
    
    def dev_mode
      @dev_mode
    end
    
    def weather_api_key
      @weather_api_key
    end
    
    def twilio_account_sid
      @twilio_account_sid
    end
    
    def twilio_auth_token
      @twilio_auth_token
    end
    
    def twilio_number
      @twilio_number
    end
    
  end
end
