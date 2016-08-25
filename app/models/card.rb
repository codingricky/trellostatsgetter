require 'trello'

class Card
  attr_reader :id
  # def id
  #   @id
  # end
  attr_reader :list_id
  attr_reader :name
  attr_reader :list_name

  def initialize(board, name, id, list_id)
    @name = name
    @id = id
    @list_id = list_id
    @list_name = Card.find_list_name(board, list_id)
  end

  def self.find_list_name(board, list_id)
    board.lists.collect do |list|
      if list.id == list_id
        return list.name
      end
    end
  end
end