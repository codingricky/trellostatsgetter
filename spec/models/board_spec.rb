require 'rspec'
require 'spec_helper'

describe Board do
  before do
    @board = Board.new
    @cards = [ 'card1', 'card2' ]
    @lists = [ 'list1', 'list2' ]
    @actions = [ 'action1', 'action2' ]
  end

  it 'can be initialized with no explicit arguments' do
    @board.cards.should eq(nil)
    @board.lists.should eq(nil)
    @board.actions.should eq(nil)
  end

  it 'can take arguments for attributes; cards, lists, and actions' do
    @board.cards = @cards
    @board.lists = @lists
    @board.actions = @actions
    @board.cards.first.should eq(@cards.first)
    @board.lists.first.should eq(@lists.first)
    @board.actions.first.should eq(@actions.first)
  end
end