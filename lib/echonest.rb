require 'open-uri'
require 'json'
require 'uri'

module Echonest
  API_KEY="9IFWEWIXWHRQCQ3I8"

  class Api
    def self.api(noun, params, debug=false)
      query_params = ""
      params.each do |key,value|
        if value.kind_of?(Array)
          value.each do |x|
            query_params = "#{query_params}&#{URI.escape(key.to_s)}=#{URI.escape(x.to_s)}"
          end
          next
        end
        query_params = "#{query_params}&#{URI.escape(key.to_s)}=#{URI.escape(value.to_s)}"
      end
      url = "http://developer.echonest.com/api/v4/#{noun}?api_key=#{API_KEY}&format=json&bucket=id:rdio-us-streaming#{query_params}"
      puts "calling url #{url}"
      Rails.logger.info "calling url #{url}"
      return url if debug
      response = JSON.parse(open(url).read)
    end

    def self.find_songs(artist_id)
      Rails.logger.info "getting songs for artist id #{artist_id}"
      puts "getting songs for artist id #{artist_id}"
      response =  api("song/search", {results: 1000, artist_id:artist_id, limit:true, bucket:["audio_summary","tracks", "song_hotttnesss"]})
      return response["response"]["songs"]
    end

    def self.find_song(artist, title)
      response =  api("song/search", {results: 1, artist:artist, title:title, limit:true})
      return response["response"]["songs"][0]
    end

    def self.find_artist_by_seatwave_id(seatwave_id)
      response = api("artist/profile", {id: "seatwave:artist:#{seatwave_id}", bucket:["blogs","biographies", "familiarity", "hotttnesss", "images", "news", "reviews"]}, false)
      return response["response"]["artist"]
    end
  end
end
