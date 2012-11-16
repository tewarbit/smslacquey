
class MovieTimes
  def initialize(title, times) 
    @title = title 
    @times = times
  end 
  
  def title 
    @title
  end
  
  def response_string
    response = "#{@title} "
    @times.each do | time |
      response = response + time + ' '
    end
    
    response
  end
  
  def times_as_string
    response = ""
    @times.each do | time |
      response = response + time + ' '
    end
  
    response
  end
  
end