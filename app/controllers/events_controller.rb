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
  end
end
