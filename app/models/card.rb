require 'trello'

class Card < ApplicationRecord

  def self.find_trello_data
    me = Trello::Member.find('***REMOVED***')
    if me.present?
      Card.find_board(me)
    end
  end

  def self.find_board(me)
    board = me.boards.first
    Card.find_cards(board)
  end

  def self.find_cards(board)
    cards = Array.new
    board.cards.collect do |card|
        cardStruct = OpenStruct.new
        cardStruct.name = card.name
        cardStruct.id = card.id
        cards << cardStruct
    end
    return cards
  end
end