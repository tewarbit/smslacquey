require 'singleton'
require 'rubygems'
require 'orderedhash'

require 'lib/config'


module SmsLacquey
  
  class MovieTimesFilter
    include Singleton
    
    private
    def match_movie(title, msg_words)
      title_words = title.downcase.scan(/[\w']+/)
      (msg_words.select { |word| title_words.include?(word) }).size == msg_words.size
    end
    
    def remove_3d_imax_if_necessary(movie_list, is3D, isIMAX)
      if (movie_list.size > 1)
        filtered = movie_list.select do |movie|
          title_words = movie.title.downcase.scan(/[\w']+/)
          movie_is3D = title_words.include? '3d'
          movie_isIMAX = title_words.include? 'imax'
          is3D == movie_is3D && isIMAX == movie_isIMAX
        end
        
        if (filtered.size == 1)
          movie_list = filtered
        else
          movie_list = [movie_list[0]]
        end
      end
      
      movie_list
    end
    
    public
    def filter_movies(movie_info, msg_body)
      filtered = OrderedHash.new
      
      msg_body_words = msg_body.downcase.scan(/[\w']+/)
      is3D = msg_body_words.include? '3d'
      isIMAX = msg_body_words.include? 'imax'
      filtered_words = msg_body_words.delete_if{|word| word == "imax" || word == "3d"}

      movie_info.each do | theater, movie_list |
        
        filtered_movie_list = movie_list.select { |movie| match_movie(movie.title, filtered_words) }
        filtered_movie_list = remove_3d_imax_if_necessary(filtered_movie_list, is3D, isIMAX)
        
        
        #   title_words = movie.title.downcase.scan(/[\w']+/)
        #   movie_is3D = title_words.include? '3d'
        #   movie_isIMAX = title_words.include? 'imax'  
        #   
        # end

        if filtered_movie_list.size > 0
          filtered[theater] = filtered_movie_list
        end

      end
      
      filtered
    end
    
  end

end