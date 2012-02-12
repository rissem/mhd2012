class EventsController < ApplicationController
  def index
    @events = Event.within params[:city]
    @events.sort! do |e1, e2|
      e1["Date"].<=>(e2["Date"])
    end
    @city = params[:city]
  end

  def show
    @event = Event.find(params[:id])
    rdio = Rdio.new(["qctgwuaxasv6jp67wurqxuuf", "VCtx6nCTZy"])
    domain = "localhost" if Rails.env.development?
    domain = "mhd2012.heroku.com" if Rails.env.production?    
    @playbackToken = rdio.call("getPlaybackToken", {domain: domain})["result"]
  end
end
