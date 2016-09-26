require 'trello'

class CardService
  def self.all
    Trello.configure do |config|
      config.developer_public_key = ENV['DEVELOPER_PUBLIC_KEY']
      config.member_token = ENV['MEMBER_TOKEN']
    end
    member = find_member
    board = member.boards.find { |board| (board.name == ENV['BOARD_NAME']) }
    board.cards.collect{|card| Card.new(board, card.name, card.id, card.list_id)}
  end

  def self.find_member
    Trello::Member.find(ENV['MEMBER_ID'])
  end
end