class EventsController < ApplicationController
  def index
    @events = Event.within params[:city]
  end
end
