require 'twilio-ruby'
require 'appengine-apis/logger'
require 'lib/config'
require 'singleton'

module SmsLacquey
  class Smser
    include Singleton
    
  def initialize
    @logger = AppEngine::logger.new
    @twilio_client = Twilio::REST::Client.new Config.instance.twilio_account_sid, Config.instance.twilio_auth_token    
  end
  
  def send_message( to, msg )
    if msg.length > 160 then
      logger.warn "Attempting to send message (#{msg}) that is of illegal length: #{msg.length}. Truncating to max length of 160 characters"

      msg.slice!(0, 156)
      msg = msg + '...'
    end
    
    @twilio_client.account.sms.messages.create(
      :from => Config.instance.twilio_number,
      :to => to,
      :body => msg
    )
    
  end
  
  end
end

