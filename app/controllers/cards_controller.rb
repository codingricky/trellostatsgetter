require 'logging'

logger = Logging.logger(STDOUT)
logger.level = :warn
logger.warn 'Only log messages that are warnings or higher will be logged.'

class CardsController < ApplicationController
  def index
    begin
      params['days_old'] = '90' if params['days_old'].nil?
      params['location'] = 'Sydney - Software Engineers' if params['location'].nil?
      params['show_only'] = 'active_cards' if params['show_only'].nil?
      raise 'Error: Please input a valid maximum days value.' if params['days_old'].to_i < 0
      @cards = TimeFilterService.filter_cards(params['days_old'].to_i, params['location'], params['show_only'])
      @error = 'No cards.' if @cards.empty?
      @location = params['location']
      @days_old = params['days_old'].to_i
      @show_only = params['show_only']
    rescue RuntimeError => e
      @error = e.message
    end
  end
end
