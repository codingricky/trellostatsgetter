class Board
  attr_accessor :cards
  attr_accessor :lists
  attr_accessor :actions
  attr_accessor :name
  #always parse into these with an array
  #e.g. Board.actions = [ action1, action2 ]
  def initialize
    @name = 'Sydney - Software Engineers'
  end
end
