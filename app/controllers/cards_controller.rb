require 'logging'

logger = Logging.logger(STDOUT)
logger.level = :warn
logger.warn 'Only log messages that are warnings or higher will be logged.'

class CardsController < ApplicationController
  def index
    @days_old = params['days_old'] || 90
    @location = params['location'] || 'Sydney - Software Engineers'

    @show_only = true
    @show_only = nil if params['show_only'] == 'all_cards'
    @show_only = false if params['show_only'] == 'inactive_cards'

    raise 'Error: Please input a valid maximum days value.' if params['days_old'].to_i < 0
    @cards = DownloadedCard.search(@location, @days_old.to_i, @show_only)
    @show_only = params['show_only']
    @error = 'No cards.' if @cards.empty?
  end

  def download
    DownloadedCardService.download_cards
    render :nothing => true, :status => 200
  end
end
