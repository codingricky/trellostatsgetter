require 'rspec'
require 'spec_helper'

describe "Constructors used for tests" do
  describe Action do
    before do
      @action_type_create = 'createCard'
      @action_type_update = 'updateCard'
      @action_id = '1'
      @action_date = '1990'
    end

    it "takes three arguments and creates a createCard action" do
      action = Action.new(@action_type_create, @action_id, @action_date)
      action.type.should eq(@action_type_create)
      action.data.should eq({"list"=>{"name"=>"Resumes to be Screened"},
                             "card"=>
                                 {"id"=>@action_id}})
      action.date.should eq(@action_date)
    end

    it "takes three arguments and creates an updateCard action" do
      action = Action.new(@action_type_update, @action_id, @action_date)
      action.type.should eq(@action_type_update)
      action.data.should eq({"listAfter"=>{"name"=>"Resumes to be Screened"},
                             "card"=>
                                 {"id"=>@action_id}})
      action.date.should eq(@action_date)
    end
  end

  describe Member do
    before do
      @member = Member.new
      @board_list = [ 'board1', 'board2' ]
    end

    it "can be initialized with no explicit arguments" do
      @member.boards.should eq(nil)
    end

    it "can take an array for attribute boards" do
      @member.boards = @board_list
      @member.boards.first.should eq(@board_list.first)
    end
  end

  describe Board do
    before do
      @board = Board.new
      @cards = [ 'card1', 'card2' ]
      @lists = [ 'list1', 'list2' ]
      @actions = [ 'action1', 'action2' ]
    end

    it "can be initialized with no explicit arguments" do
      @board.cards.should eq(nil)
      @board.lists.should eq(nil)
      @board.actions.should eq(nil)
    end

    it "can take arguments for attributes; cards, lists, and actions" do
      @board.cards = @cards
      @board.lists = @lists
      @board.actions = @actions
      @board.cards.first.should eq(@cards.first)
      @board.lists.first.should eq(@lists.first)
      @board.actions.first.should eq(@actions.first)
    end
  end

  describe List do
    before do
      @list_name = 'Sample List Name'
      @list_id = '1'
    end

    it "takes two arguments and creates the list" do
      @list = List.new(@list_id, @list_name)
      @list.id.should eq(@list_id)
      @list.name.should eq(@list_name)
    end
  end
end
