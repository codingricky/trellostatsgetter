require 'rspec'
require 'spec_helper'
require 'trello'

describe ActionCache do
  before "receives all actions from a board" do
    @board = Board.new
    @actions1 = [ ]
    @actions2 = [ ]
    @board.actions = [ ]
    i = 1005
    while i > 5
      sample_action = OpenStruct.new
      sample_action.id = i
      @actions1 << sample_action
      @board.actions << sample_action
      i = i - 1
    end
    while i > 0
      sample_action = OpenStruct.new
      sample_action.id = i
      @actions2<< sample_action
      @board.actions << sample_action
      i = i - 1
    end
    @board.cards = [ ]
    @board.lists = [ ]
    @board.name = 'Test Board'
  end

  it "paginates them into an array, and returns the array" do
    ActionCache.any_instance.should_receive(:get_actions_from_board).at_least(:once).and_return(@actions1)
    ActionCache.any_instance.should_receive(:get_actions_from_board_before).at_least(:once).and_return(@actions2)
    test_cache = ActionCache.new(@board)
    test_cache.actions.count.should eq(2)
    test_cache.actions.first.count.should eq(1000)
    test_cache.actions.last.count.should eq(5)
    total = ((test_cache.actions.count - 1) * 1000 + test_cache.actions.last.count)
    total.should eq(1005)
  end
end
