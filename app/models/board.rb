class Board
  attr_accessor :cards
  attr_accessor :lists
  attr_accessor :actions
  attr_accessor :name
  attr_accessor :id
  #always parse into these with an array, except name and id.
  #e.g. Board.actions = [ action1, action2 ]
  def initialize
    @name = 'Sydney - Software Engineers'
    @id = '55ac308c4ae6522bbe90f501'
  end
end
