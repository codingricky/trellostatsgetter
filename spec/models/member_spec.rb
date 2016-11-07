require 'rspec'
require 'spec_helper'

describe Member do
  before do
    @member = Member.new
    @board_list = [ 'board1', 'board2' ]
  end

  it 'can be initialized with no explicit arguments' do
    @member.boards.should eq(nil)
  end

  it 'can take an array for attribute boards' do
    @member.boards = @board_list
    @member.boards.first.should eq(@board_list.first)
  end
end