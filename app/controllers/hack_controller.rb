require 'echonest'

class HackController < ApplicationController
  def index
    @song = Echonest::Api.find_song("jimi hendrix", "all along the watchtower")
  end
end
