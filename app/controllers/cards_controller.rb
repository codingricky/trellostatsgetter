class CardsController < ApplicationController
  def index
    @cards = CardService.all
    if @cards == [ ]
      @cards = 'No cards.'
    end
  rescue => error
    if error.message == 'invalid token'
      @cards = 'Error: Member Token is invalid/not found.'
    end
    if error.message == 'model not found'
      @cards = 'Error: Member ID is invalid/not found.'
    end
    if error.message == 'Board name is invalid/not found.'
      @cards = 'Error: Board name is invalid/not found.'
    end
    if @cards.nil?
      raise error.message
    end
  end
end