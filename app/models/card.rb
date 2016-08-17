require 'trello'

class Card < ApplicationRecord

  def self.delete_duplicates
    grouped = all.group_by{|card| [card.creator, card.messagebody]}
    grouped.values.each do |duplicates|
      duplicates.pop
      duplicates.each{|double| double.destroy}
    end
  end

  def self.get_trello_authentication
    Trello.configure do |config|
      config.developer_public_key = ENV['DEVELOPER_PUBLIC_KEY']
      config.member_token = ENV['MEMBER_TOKEN']
    end
    Card.find_member
  end

  def self.find_member
    me = Trello::Member.find('***REMOVED***')
    Card.find_board(me)
  end

  def self.find_board(me)
    board = me.boards.first
    Card.collect_cards(board)
  end

  def self.collect_cards(board)
    board.cards.collect do |card|
        Card.store_in_db(card)
    end
  end

  def self.store_in_db(card)
    Card.create do |localcard|
      localcard.creator = card.id
      localcard.messagebody = card.name
    end
  end
end