require 'rspec'
require 'spec_helper'

describe "Constructors used for tests" do
  describe Action do
    it "takes three arguments and creates a createCard action" do
      action = Action.new('createCard', '1', '1990')
      action.type.should eq('createCard')
      action.data.should eq({"list"=>{"name"=>"Resumes to be Screened"},
                             "card"=>
                                 {"id"=>'1'}})
      action.date.should eq('1990')
    end

    it "takes three arguments and creates an updateCard action" do
      action = Action.new('updateCard', '2', '1991')
      action.type.should eq('updateCard')
      action.data.should eq({"listAfter"=>{"name"=>"Resumes to be Screened"},
                             "card"=>
                                 {"id"=>'2'}})
      action.date.should eq('1991')
    end
  end

  describe Member do
    before do
      @member = Member.new
    end

    it "can be initialized with no explicit arguments" do
      @member.boards.should eq(nil)
    end

    it "can take an array for attribute boards" do
      @member.boards = [ 'board1', 'board2' ]
      @member.boards.first.should eq('board1')
    end
  end

  describe Board do
    before do
      @board = Board.new
    end

    it "can be initialized with no explicit arguments" do
      @board.cards.should eq(nil)
      @board.lists.should eq(nil)
      @board.actions.should eq(nil)
    end

    it "can take arguments for attributes; cards, lists, and actions" do
      @board.cards = ['card1', 'card2']
      @board.lists = ['list1', 'list2']
      @board.actions = ['action1', 'action2']
      @board.cards.first.should eq('card1')
      @board.lists.first.should eq('list1')
      @board.actions.first.should eq('action1')
    end
  end

  describe List do
    it "takes two arguments and creates the list" do
      @list = List.new('1', 'Sample List Name')
      @list.id.should eq('1')
      @list.name.should eq('Sample List Name')
    end
  end
end
