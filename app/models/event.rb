class Event < ActiveRecord::Base
  def self.within(city)
    response = JSON.parse(open("http://api-sandbox.seatwave.com/v2/discovery/events?apikey=4739E4694D0E482A92C9D0B478D83934&what=music&where=#{URI.escape(city)}").read)
    return response["Events"]    
  end
end

