class CardsController < ApplicationController
  def index
    @cards = CardService.all
    @cards.sort! { |a, b| b.start_date.to_i <=> a.start_date.to_i }
    @error = nil
    if @cards == [ ]
      @error = 'No cards.'
    end
  rescue => error
    if error.message == 'invalid token'
      @error = 'Error: Member Token is invalid/not found.'
    end
    if error.message == 'model not found'
      @error = 'Error: Member ID is invalid/not found.'
    end
    if error.message == 'Board name is invalid/not found.'
      @error = 'Error: Board name is invalid/not found.'
    end
    if @error.nil?
      raise error.message
    end
  end
end