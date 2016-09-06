require 'rspec'
require 'spec_helper'
require 'trello'

describe Card do
  context "Trello api returns data with one card" do
    before do
      @list_name = 'Success - This is a sample end lane'
      list_id = '1'
      action_type = 'createCard'
      action_card_id = '1'
      @action_date = '1/1/1991'
      action_type_finish = 'updateCard_finish'
      @action_date_finish = '1/1/1992'
      @card_name = 'Bob'
      card_id = '1'
      card_list_id = '1'
  #TODO local variable scope
      list = List.new(list_id, @list_name)
      action = Action.new(action_type, action_card_id, @action_date)
      action2 = Action.new(action_type_finish, action_card_id, @action_date_finish)
      board = Board.new
      board.lists = [ list ]
      board.actions = [ action, action2 ]
      @card = Card.new(board, @card_name, card_id, card_list_id)
    end

    it "gets the card's name" do
      @card.name.should eq(@card_name)
    end

    it "gets the card's list name" do
      @card.list_name.should eq(@list_name)
    end

    it "gets the card's start date" do
      @card.start_date.should eq(@action_date.to_datetime.strftime('%d %b %Y'))
    end

    it "gets the card's end date" do
      @card.end_date.should eq(@action_date_finish.to_datetime.strftime('%d %b %Y'))
    end
  end

  context "Trello api returns data with three lists" do
    before do
      @list_name = 'The List'
      list_id = '2'
      dudlist_name = 'Dud List'
      dudlist_id = '1'
      dudlist2_name = 'Another dud List'
      dudlist2_id = '3'
      action_type = 'createCard'
      action_id = '2'
      action_date = '1/1/1991'
      @card_name = 'Bob'
      @card_id = '1'
      @card_list_id = '2'

      list = List.new(list_id, @list_name)
      dudlist = List.new(dudlist_id, dudlist_name)
      dudlist2 = List.new(dudlist2_id, dudlist2_name)
      action = Action.new(action_type, action_id, action_date)
      @board = Board.new
      @board.lists = [ list, dudlist, dudlist2 ]
      @board.actions = [ action ]
    end

    it "finds the right list" do
      @card = Card.new(@board, @card_name, @card_id, @card_list_id)
      @card.list_name.should eq(@list_name)
    end
  end

  context "Trello api returns data with multiple updateCard actions" do
    before do
      list_name = 'The List'
      list_id = '2'
      action_type = 'updateCard'
      action_id = '2'
      @action_date = '1/1/2001'
      oldaction_type = 'updateCard'
      oldaction_id = '2'
      oldaction_date = '1/1/1995'
      wrongaction_type = 'updateCard'
      wrongaction_id = '1'
      wrongaction_date = '1/1/1991'
      wrongaction2_type = 'createCard'
      wrongaction2_id = '1'
      wrongaction2_date = '1/1/1991'
      @card_name = 'Bob'
      @card_id = '2'
      @card_list_id = '2'
      list = List.new(list_id, list_name)
      action = Action.new(action_type, action_id, @action_date)
      oldaction = Action.new(oldaction_type, oldaction_id, oldaction_date)
      wrongaction = Action.new(wrongaction_type, wrongaction_id, wrongaction_date)
      wrongaction2 = Action.new(wrongaction2_type, wrongaction2_id, wrongaction2_date)
      @board = Board.new
      @board.lists = [ list ]
      @board.actions = [ action, oldaction, wrongaction, wrongaction2 ]
    end

    it "finds the right action and gets the card's start date" do
      @card = Card.new(@board, @card_name, @card_id, @card_list_id)
      @card.start_date.should eq(@action_date.to_datetime.strftime('%d %b %Y'))
    end
  end
end