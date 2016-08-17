class CardsController < ApplicationController
  def index
    Card.get_trello_authentication
    Card.delete_duplicates
	  @cards = Card.all
  end
end
