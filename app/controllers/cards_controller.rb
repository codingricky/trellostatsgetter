require 'logging'

logger = Logging.logger(STDOUT)
logger.level = :warn
logger.warn 'Only log messages that are warnings or higher will be logged.'

class CardsController < ApplicationController
  def index
    begin
      params['days_old'] = '90' if params['days_old'].nil?
      params['location'] = 'Sydney - Software Engineers' if params['location'].nil?
      raise 'Error: Please input a valid maximum days value.' if params['days_old'].to_i < 0
      @cards = TimeFilterService.filter_cards(params['days_old'].to_i, params['location'])
      @error = 'No cards.' if @cards.empty?
      @location = params['location']
      @days_old = params['days_old'].to_i
    rescue RuntimeError => e
      @error = e.message
    end
  end
end
