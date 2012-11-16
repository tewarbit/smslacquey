require 'appengine-apis/logger'


module SmsLacquey
  
  class MovieTimesSteward
    
    def initialize
      @logger = AppEngine::Logger.new
    end
    
    def match(msg_body)
      urlFetch = AppEngine::URLFetch.fetch('http://www.google.com/movies?hl=en&near=48103&dq=showtimes+48103&q=showtimes&sa=X', {:deadline => 60})  

      doc = Nokogiri::HTML(urlFetch.body)
      movie_info = MovieTimesParser.instance.get_movie_times()
      
      movie_info = MoveTimesFilter.instance.filter_movies(movie_info, msg_body)
     
     MovieTimesRenderer.instance.render_message(movie_info)
      
    end
    
  end
  
end