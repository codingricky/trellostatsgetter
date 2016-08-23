class CardsController < ApplicationController
  def index
    CardService.trello_authenticator
	  @cards = Card.find_trello_data
  end
end
