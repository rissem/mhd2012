require 'open-uri'
require 'json'
require 'uri'

module Echonest
  API_KEY="9IFWEWIXWHRQCQ3I8"

  class Api
    def self.api(noun, params)
      query_params = ""
      params.each do |key,value|
        query_params = "#{query_params}&#{URI.escape(key.to_s)}=#{URI.escape(value.to_s)}"
      end
      url = "http://developer.echonest.com/api/v4/#{noun}?api_key=#{API_KEY}&format=json&bucket=id:rdio-us-streaming#{query_params}"
      response = JSON.parse(open(url).read)
      #TODO raise error if response code is not zero
    end

    def self.find_song(artist, title)
      response =  api("song/search", {results: 1, artist:artist, title:title, limit:true})
      return response["response"]["songs"][0]
    end

    def self.upcoming_events(city)
      response = JSON.parse(open("http://api-sandbox.seatwave.com/v2/discovery/events?apikey=4739E4694D0E482A92C9D0B478D83934&what=music&where=#{URI.escape(city)}").read)
      events = response["Events"]
      events[0..5].each do |event|
        puts event["EventGroupId"]
        puts find_artst_by_seatwave_id(event["EventGroupId"])
      end
    end

    def self.find_artst_by_seatwave_id(seatwave_id)
      api("artist/profile", {id: "seatwave:artist:#{seatwave_id}", bucket:"biographies"})
    end
  end
end
