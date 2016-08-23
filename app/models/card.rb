require 'trello'

class Card < ApplicationRecord

  cardId = 'lol'
  listId = 'lol'
  cardName = 'lol'
  startDate = 'lol'
  endDate = 'lol'

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
    Card.find_list(board)
  end

  def self.find_list(board)
    listIds = Array.new
    board.lists.collect do |list|
      if list.name.include?('Success -')
        listIds << list.id
      end
    end
    Card.find_card(board, listIds)
  end

  def self.find_card(board, listIds)
    cardInfo = OpenStruct.new
    board.cards.collect do |card|
      if listIds.include? card.list_id
        cardInfo.idList = card.list_id
        cardInfo.idCard = card.id
        cardInfo.nameCard = card.name
      end
    end
    Card.find_actions(board, cardInfo)
  end

  def self.find_actions(board, cardInfo)
      board.actions.collect do |action|
        if action.type == "createCard"
          if cardInfo.idCard.include? action.data['card']['id']
            cardInfo.startDate = action.date
          end
        end
        if action.type == "updateCard"
          if cardInfo.idCard.include? action.data['card']['id']
            if cardInfo.idList == action.data['listAfter']['id']
              cardInfo.endDate = action.date
            end
          end
      end
      end
      return cardInfo.endDate
  end

  # def self.collect_cards(board)
  #   board.cards.collect do |card|
  #       Card.store_in_db(card)
  #   end
  # end
  #
  # def self.store_in_db(card)
  #   Card.create do |localcard|
  #     localcard.creator = card.id
  #     localcard.messagebody = card.name
  #   end
  # end
end