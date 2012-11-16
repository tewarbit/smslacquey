require 'singleton'
require 'rubygems'
require 'orderedhash'

require 'lib/config'
require 'lib/smslacquey/movietimes/movietimes'


module SmsLacquey
  
  class MovieTimesParser
    include Singleton
    
    def initialize
      if (Config.instance.dev_mode)

      else
        @logger = AppEngine::Logger.new
      end
    end
    
    private
    def get_theater_name(node)
      theater_name = ""
      
      node.xpath('.//h2[@class="name"]/a').each do | theater_name |
        theater_name = theater_name.content
      end
      
      theater_name
    end
    
    def get_movies(node)
      movies = []

      node.xpath('.//div[@class="movie"]').each do | movie_node |
        movie_name = movie_node.xpath('.//div[@class="name"]/a').first().content
        
        movie_times = []
        movie_node.xpath('.//div[@class="times"]/span/text()').each do | movie_time |
          movie_times.push(movie_time.content.scan(/\d{1,2}:\d\d[amp]{0,2}/)[0])
        end

        #puts "new movie time: #{movie_name} | #{movie_times}"
        movies.push(MovieTimes.new(movie_name, movie_times))
      end
      
      movies
    end
    
    public
    def get_movie_times(doc)
      movie_info = OrderedHash.new

      doc.xpath('//div[@class="theater"]').each do | theater_node |  
        theaterName = get_theater_name(theater_node)
        #puts "--- adding movies for theatre: #{theaterName}"
        movie_info[theaterName] = get_movies(theater_node)
      end
    
      movie_info
    end
    
  end

end