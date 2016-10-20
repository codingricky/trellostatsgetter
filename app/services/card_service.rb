require 'trello'

class CardService
  def self.all
    Trello.configure do |config|
      config.developer_public_key = "27dbf126a87c20a0a1a6c9f81fcc2e98"
      config.member_token = ENV['TRELLO_MEMBER_TOKEN']
    end
    member = find_member
    Rails.logger.info("calling member.boards")
    board = member.boards.find { |board| (board.name == ENV['TRELLO_BOARD_NAME']) }
    raise 'Board name is invalid/not found.' unless board.present?

    action_cache = ActionCache.new(board)
    Rails.logger.info("calling board.cards")
    all_cards = board.cards.collect{|card| Card.new(create_list_id_to_name(board), card.name, card.id, card.list_id, action_cache.actions)}
    Rails.logger.info("calling all_cards.find_all")
    all_cards.find_all{ |card| card.start_date != 'Error' }
  end

  def self.find_member
    Rails.logger.info("calling Trello find")
    Trello::Member.find(ENV['TRELLO_MEMBER_ID'])
  end

  def self.create_list_id_to_name(board)
    lists = board.lists
    list_id_to_name = {}
    lists.each do |list|
      list_id_to_name[list.id] = list.name
    end
    return list_id_to_name
  end

end