class EventsController < ApplicationController
  def index
    @events = Event.within params[:city]
  end

  def show
    @event = Event.find(params[:id])
  end
end
