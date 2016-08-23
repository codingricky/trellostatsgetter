class CardsController < ApplicationController
  def index
    Card.get_trello_authentication
	  @cards = Card.all
  end

  def update
    Card.get_trello_authentication
    redirect_to root_path
  end

  def delete
    Card.delete_duplicates
    redirect_to root_path
  end
end
