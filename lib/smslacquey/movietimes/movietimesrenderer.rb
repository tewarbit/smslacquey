require 'singleton'
require 'rubygems'

require 'lib/config'


module SmsLacquey
  
  class MovieTimesRenderer
    include Singleton
    
    public
    def render_message(movie_info)
      movie_info_array = movie_info.to_a.take(3)
      
      response = ""
      movie_info_array.each {|info| response = response + info[0] + info[1][0].response_string}
      
      response
    end
    
  end

end