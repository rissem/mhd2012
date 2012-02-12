require 'open-uri'
require 'echonest'

class Event 
  attr_accessor :data

  def self.within(city)
    city = "San Francisco" unless city
    response = JSON.parse(open("http://api-sandbox.seatwave.com/v2/discovery/events?apikey=4739E4694D0E482A92C9D0B478D83934&what=music&where=#{URI.escape(city)}").read)
    return response["Events"]
  end

  def self.find(id)
    response = JSON.parse(open("http://api-sandbox.seatwave.com/v2/discovery/event/#{id}?apikey=4739E4694D0E482A92C9D0B478D83934").read)
    event = Event.new
    event.data = response["Event"]
    return event
  end

  def artist_info
    @artist_info = Echonest::Api.find_artist_by_seatwave_id(data["EventGroupId"]) unless @artist_info
    return @artist_info
  end

  def artist_songs
    Echonest::Api.find_songs(artist_info["id"])
  end
end

