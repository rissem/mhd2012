require 'open-uri'
require 'echonest'
require 'rdio'

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

  def artist_albums
    rdio_artist_id = artist_info["foreign_ids"][0]["foreign_id"].split(":")[-1]
    rdio = Rdio.new(["qctgwuaxasv6jp67wurqxuuf", "VCtx6nCTZy"])
    track_response = rdio.call("getTracksForArtist", {artist:rdio_artist_id, count:1000})
    album_response = rdio.call("getAlbumsForArtist", {artist:rdio_artist_id, count:1000})
    albums = {}

    album_response["result"].each do |album|
      albums[album["name"]] = {}
      albums[album["name"]]["info"] = album
    end

    track_response["result"].each do |song|
      albums[song["album"]] = {} unless albums[song["album"]]
      albums[song["album"]]["tracks"] = [] unless albums[song["album"]]["tracks"]
      albums[song["album"]]["tracks"] << song
    end

    albums.each do |album_name, album|
      if album["tracks"]
        album["tracks"].sort! do |song1, song2|
          song1["trackNum"].<=>(song2["trackNum"])
        end
      end
    end

    sorted_albums = []
    albums.each do |album_name, album|
      sorted_albums << album if album["info"]
    end

    sorted_albums.sort! do |album1, album2|
      if album1["info"] and album2["info"]
        result =  (album2["info"]["releaseDate"]).<=>(album1["info"]["releaseDate"])
      else
        result = 1
      end
      result
    end
    
    return sorted_albums
  end
end

