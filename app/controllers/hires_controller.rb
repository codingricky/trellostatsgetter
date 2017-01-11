class HiresController < ApplicationController

  def index
    @days = params[:days] || 90
    @location = params[:location] || Board.first.location
    @cards = DownloadedCard.all.find_all { |card| card.hired_more_recent_than(@days) && card.location == @location }
    @hires = @cards.size
  end

end