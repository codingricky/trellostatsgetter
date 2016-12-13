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
    since_date = (DateTime.current - 999999).to_s
    ActionService.stub(:since_date).with(999999).and_return(since_date)
    @board.stub(:actions).with(limit: 1000, since: since_date).and_return(@actions1)
    @board.stub(:actions).with(limit: 1000, before: 999).and_return(@actions2)
    list_of_actions = ActionService.get_actions(@board, 999999)
    list_of_actions.count.should eq(@actions1.count + @actions2.count)
  end
end
