require 'sinatra'
require 'nokogiri'   
require 'appengine-apis/urlfetch'
require 'appengine-apis/logger'
require 'twilio-ruby'
require 'lib/smser'
require 'lib/smslacquey/requesthandler'

module SmsLacquey
  
  class App < Sinatra::Base
  
    class << self
       def init
         #init stuff here
       end
    end
  
    get '/' do
      File.read(File.join('public', 'index.html'))
    end
    
    get '/*' do
      "404. No can-do buddy"
    end

    post '/sms' do
      from_number = params[:From]
      message_body = params[:Body]
      is_web = params[:isWeb]

      logger = AppEngine::Logger.new
      logger.info "Received (isWeb=#{is_web}) text from: #{from_number} saying: #{message_body}"
      
      @request_handler = RequestHandler.new()
      response = @request_handler.handle_request(from_number, message_body)

      # twiml_response = "<Response><Sms>#{response}</Sms></Response>"

      logger.info "Responding to request with: #{response}"

      if "true" == is_web then
        return response
      else
        Smser.instance.send_message( from_number, repsonse )
      end


    end

    post '/' do
      puts "processed post request"
    end

  end
end

