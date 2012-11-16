require 'test/unit'
require 'lib/smslacquey/movietimes/movietimesparser'
require 'lib/smslacquey/movietimes/movietimesfilter'
require 'lib/smslacquey/movietimes/movietimesrenderer'


require 'rubygems'
require 'nokogiri'

class TestMovieTimesRenderer < Test::Unit::TestCase
  
  def test_simple_movie_find
    f = File.open("test/sample_movie.html")
    doc = Nokogiri::HTML(f)
    
    result =  SmsLacquey::MovieTimesParser.instance.get_movie_times(doc)
    
    result = SmsLacquey::MovieTimesFilter.instance.filter_movies(result, "wreck")
    
    message = SmsLacquey::MovieTimesRenderer.instance.render_message(result)
    puts "message is: #{message}"
    assert message.length <= 160
    
  end

end