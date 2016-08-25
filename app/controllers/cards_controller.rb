class CardsController < ApplicationController
  def index
    @cards = CardService.all
  end
end
