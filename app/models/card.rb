require 'trello'

class Card < ApplicationRecord

  def self.delete_duplicates
    grouped = all.group_by{|card| [card.creator, card.messagebody]}
    grouped.values.each do |duplicates|
      duplicates.pop
      duplicates.each{|double| double.destroy}
    end
  end

  def self.getcards
    Trello.configure do |config|
      config.developer_public_key = ENV['DEVELOPER_PUBLIC_KEY']
      config.member_token = ENV['MEMBER_TOKEN']
    end

    me = Trello::Member.find("***REMOVED***")

    board = me.boards.first

    board.cards.collect do |card|
      Card.create do |localcard|
        localcard.creator = card.id
        localcard.messagebody = card.name
      end
    end
    Card.delete_duplicates
  end
end