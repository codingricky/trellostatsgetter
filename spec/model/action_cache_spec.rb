require 'rspec'
require 'spec_helper'
require 'trello'

describe ActionCache do
  before "receives all actions from a board" do
    @board = Board.new
    @actions1 = [ ]
    @actions2 = [ ]
    @board.actions = [ ]
    @actions1 = 0.upto(999).collect{|i| OpenStruct.new(id: i)}
    @actions2 = 1000.upto(1005).collect{|i| OpenStruct.new(id: i)}
    @board.cards = [ ]
    @board.lists = [ ]
    @board.name = 'Test Board'
  end

  it "paginates them into an array, and returns the array" do
    ActionCache.any_instance.should_receive(:get_actions_from_board).at_least(:once).and_return(@actions1)
    ActionCache.any_instance.should_receive(:get_actions_from_board_before).at_least(:once).and_return(@actions2)
    test_cache = ActionCache.new(@board)
    test_cache.actions.count.should eq(@actions1.count + @actions2.count)
  end
end
