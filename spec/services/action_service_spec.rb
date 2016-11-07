require 'rspec'
require 'spec_helper'
require 'trello'

describe ActionService do
  before 'receives all actions from a board' do
    @board = double("board")
    @actions1 = 0.upto(999).collect{|i| OpenStruct.new(id: i)}
    @actions2 = 1000.upto(1005).collect{|i| OpenStruct.new(id: i)}
  end

  it "paginates them into an array, and returns the array" do
    @board.stub(:actions).with(limit: 1000).and_return(@actions1)
    @board.stub(:actions).with(limit: 1000, before: 999).and_return(@actions2)

    list_of_actions = ActionService.get_actions(@board)
    list_of_actions.count.should eq(@actions1.count + @actions2.count)
  end
end
