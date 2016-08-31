require 'rspec'
require 'spec_helper'
require 'trello'

#TODO make all the hard-coded tests into variables so one place changes all
#TODO update cukes and other rspec tests to use new constructors
describe Card do
  context "Trello api returns data with one card" do
    before do
      @list = List.new('1', 'The List')
      @action = Action.new('createCard', '1', '1/1/1991')
      @board = Board.new
      @board.lists = [ @list ]
      @board.actions = [ @action ]
      @card = Card.new(@board, 'Bob', '1', '1')
    end

    it "gets the card's name" do
      @card.name.should eq('Bob')
    end

    it "gets the card's id" do
      @card.id.should eq('1')
    end

    it "gets the card's list id" do
      @card.list_id.should eq('1')
    end

    it "gets the card's list name" do
      @card.list_name.should eq('The List')
    end

    it "gets the card's start date" do
      @card.start_date.should eq('1/1/1991')
    end
  end

  context "Trello api returns data with three lists" do
    before do
      @list = List.new('2', 'The List')
      @dudlist = List.new('1', 'Dud List')
      @dudlist2 = List.new('3', 'Another dud List')
      @action = Action.new('createCard', '2', '1/1/1991')
      @board = Board.new
      @board.lists = [ @list, @dudlist, @dudlist2 ]
      @board.actions = [ @action ]
      @card = Card.new(@board, 'Bob', '1', '2')
    end

    it "finds the right list" do
      @card.list_name.should eq('The List')
    end
  end

  context "Trello api returns data with multiple updateCard actions" do
    before do
      @list = List.new('2', 'The List')
      @action = Action.new('updateCard', '2', '1/1/2001')
      @oldaction = Action.new('updateCard', '2', '1/1/1995')
      @wrongaction = Action.new('updateCard', '1', '1/1/1991')
      @wrongaction2 = Action.new('createCard', '1', '1/1/1991')
      @board = Board.new
      @board.lists = [ @list ]
      @board.actions = [ @action, @oldaction, @wrongaction, @wrongaction2 ]
      @card = Card.new(@board, 'Bob', '2', '2')
    end

    it "finds the right action and gets the card's start date" do
      @card.start_date.should eq('1/1/2001')
    end
  end
end