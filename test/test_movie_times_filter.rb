require 'test/unit'
require 'lib/smslacquey/movietimes/movietimesparser'
require 'lib/smslacquey/movietimes/movietimesfilter'


require 'rubygems'
require 'nokogiri'

class TestMovieTimesParser < Test::Unit::TestCase
  
  def test_simple_movie_find
    f = File.open("test/sample_movie.html")
    doc = Nokogiri::HTML(f)
    
    result =  SmsLacquey::MovieTimesParser.instance.get_movie_times(doc)
    
    result = SmsLacquey::MovieTimesFilter.instance.filter_movies(result, "wreck")
    
    assert !result.has_key?("Michigan Theater - Ann Arbor")
    assert !result.has_key?("State Theater - Ann Arbor")
    
    assert_equal 1, result["Goodrich Quality 16"].length
    assert_equal 1, result["Rave Motion Pictures Ann Arbor 20 + IMAX"].length
    assert_equal 1, result["Clinton Theater - Clinton"].length
    assert_equal 1, result["The Lyon"].length
    assert_equal 1, result["MJR Brighton Towne Square Digital Cinema 20"].length
    assert_equal 1, result["Goodrich Canton 7"].length
    assert_equal 1, result["MJR Adrian Digital Cinema 10"].length
    assert_equal 1, result["Emagine Canton"].length    
    
  end

end