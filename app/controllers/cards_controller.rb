class CardsController < ApplicationController
  def index
    @cards = get_cards
  end

  def get_cards
    CardService.all
  end

  helper_method :get_cards
end
