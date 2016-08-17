class CardsController < ApplicationController
  def index
    Card.getcards
	  @cards = Card.all
  end
end
