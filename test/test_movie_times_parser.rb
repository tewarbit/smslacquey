require 'test/unit'
require 'lib/smslacquey/movietimes/movietimesparser'

require 'rubygems'
require 'nokogiri'

class TestMovieTimesParser < Test::Unit::TestCase
  
  def test_simple_movie_find
    f = File.open("test/sample_movie.html")
    doc = Nokogiri::HTML(f)
    
    result =  SmsLacquey::MovieTimesParser.instance.get_movie_times(doc)
    assert_equal 13, result["Goodrich Quality 16"].length
    assert_equal 3, result["Michigan Theater - Ann Arbor"].length
    assert_equal 3, result["State Theater - Ann Arbor"].length
    assert_equal 17, result["Rave Motion Pictures Ann Arbor 20 + IMAX"].length
    assert_equal 1, result["Clinton Theater - Clinton"].length
    assert_equal 1, result["The Lyon"].length
    assert_equal 18, result["MJR Brighton Towne Square Digital Cinema 20"].length
    assert_equal 7, result["Goodrich Canton 7"].length
    assert_equal 12, result["MJR Adrian Digital Cinema 10"].length
    assert_equal 16, result["Emagine Canton"].length
    
  end

end