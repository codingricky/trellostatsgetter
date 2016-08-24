require 'trello'

class Card
  def self.find_trello_data
    Trello::Member.find('***REMOVED***')
  end

  def self.find_board(me)
    me.boards.first
  end

  def self.find_cards(board)
    cards = Array.new
    board.cards.collect do |card|
      card_struct = OpenStruct.new
      card_struct.name = card.name
      card_struct.id = card.id
      card_struct.list_id = card.list_id
      cards << card_struct
      end
    return cards
  end
end