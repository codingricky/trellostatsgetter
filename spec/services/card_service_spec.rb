require 'rspec'
require 'spec_helper'
require 'trello'

describe CardService do
  before do
    @list_alpha = List.new('1', 'Alphas List')
    @list_bravo = List.new('2', 'Bravos List')
    @list_foreign = List.new('9', 'Foreign List')

    @card_alpha_name = 'Alpha'
    @card_alpha_id = '1'
    @card_alpha_list_id = '1'

    @card_bravo_name = 'Bravo'
    @card_bravo_id = '2'
    @card_bravo_list_id = '2'

    @card_foreign_name = 'Foreign'
    @card_foreign_id = '9'
    @card_foreign_list_id = '9'

    @action_create_alpha = Action.new('createCard', '1', '1/1/1991')
    @action_update_alpha = Action.new('updateCard', '1', '1/1/2001')
    @action_update_alpha_latest = Action.new('updateCard', '1', '1/1/2011')
    @action_create_bravo = Action.new('createCard', '2', '1/1/1992')
    @action_update_bravo = Action.new('updateCard', '2', '1/1/2002')
    @action_update_bravo_latest = Action.new('updateCard', '2', '1/1/2012')
    @action_create_foreign = Action.new('movedCard', '9', '1/1/2999')
    @first_board = Board.new
    @member = Member.new
  end

  context "receives an invalid user ID" do
    it "raises an error" do
      Trello::Member.should_receive(:find).at_least(:once).and_return(nil)
      expect { CardService.all }.to raise_error(NoMethodError)
    end
  end

  context "receives no boards" do
    it "raises an error" do
      Trello::Member.should_receive(:find).at_least(:once).and_return(@member)
      expect { CardService.all }.to raise_error(NoMethodError)
    end
  end

  context "receives a card from trello that was created in the Resumes swimlane" do
    before do
      @first_board.lists = [ @list_alpha ]
      @first_board.actions = [ @action_create_alpha ]
      action_cache = OpenStruct.new
      action_cache.actions = @first_board.actions
      card_alpha = Card.new(CardService.create_list_id_to_name(@first_board), @card_alpha_name, @card_alpha_id, @card_alpha_list_id, action_cache.actions)
      ActionCache.should_receive(:new).at_least(:once).and_return(action_cache)
      @first_board.cards = [ card_alpha ]
      @member.boards = [ @first_board ]
      Trello::Member.should_receive(:find).at_least(:once).and_return(@member)
    end

    it "puts the card's names into an array" do
      cards = CardService.all
      cards.count.should eq(1)
      cards.first.name.should eq(@card_alpha_name)
    end

    it "puts the card's swimlanes into an array" do
      cards = CardService.all
      cards.count.should eq(1)
      cards.first.list_name.should eq(@list_alpha.name)
    end

    it "puts the card's creation dates into an array" do
      cards = CardService.all
      cards.count.should eq(1)
      cards.first.start_date.should eq(@action_create_alpha.date)
      cards.first.end_date.should eq(nil)
    end
  end

  context "receives a card from trello of a card that was moved in to the Resumes to be Screened swimlane" do
    before do
      @first_board.lists = [ @list_bravo ]
      @first_board.actions = [ @action_update_bravo_latest, @action_update_bravo ]
      action_cache = OpenStruct.new
      action_cache.actions = @first_board.actions
      ActionCache.should_receive(:new).at_least(:once).and_return(action_cache)
      card_bravo = Card.new(CardService.create_list_id_to_name(@first_board), @card_bravo_name, @card_bravo_id, @card_bravo_list_id, action_cache.actions)
      @first_board.cards = [ card_bravo ]
      @member.boards = [ @first_board ]
      Trello::Member.should_receive(:find).at_least(:once).and_return(@member)
    end

    it "puts the card's date of its latest movement into the Resumes swimlane into an array" do
      cards = CardService.all
      cards.count.should eq(1)
      cards.first.start_date.should eq(@action_update_bravo_latest.date)
    end
  end

  context "receives a card from trello that has never existed in the Resumes to be Screened swimlane" do
    before do
      @first_board.lists = [ @list_bravo ]
      bad_action = Action.new('updateCard_finish', @card_bravo_id, '1/1/1990')
      @first_board.actions = [ bad_action ]
      action_cache = OpenStruct.new
      action_cache.actions = @first_board.actions
      ActionCache.should_receive(:new).at_least(:once).and_return(action_cache)
      card_bravo = Card.new(CardService.create_list_id_to_name(@first_board), @card_bravo_name, @card_bravo_id, @card_bravo_list_id, action_cache.actions)
      @first_board.cards = [ card_bravo ]
      @member.boards = [ @first_board ]
      Trello::Member.should_receive(:find).at_least(:once).and_return(@member)
    end

    it "puts a warning to the user in place of the startdate" do
      cards = CardService.all
      cards.count.should eq(1)
      cards.first.start_date.should eq(nil)
    end
  end

  context "receives multiple cards from trello that were created in the Resumes swimlane" do
    before do
      @member.boards = [ @first_board ]
      @first_board.lists = [ @list_alpha, @list_bravo ]
      @first_board.actions = [ @action_create_alpha, @action_create_bravo ]
      action_cache = OpenStruct.new
      action_cache.actions = @first_board.actions
      ActionCache.should_receive(:new).at_least(:once).and_return(action_cache)
      card_bravo = Card.new(CardService.create_list_id_to_name(@first_board), @card_bravo_name, @card_bravo_id, @card_bravo_list_id, action_cache.actions)
      card_alpha = Card.new(CardService.create_list_id_to_name(@first_board), @card_alpha_name, @card_alpha_id, @card_alpha_list_id, action_cache.actions)
      @first_board.cards = [ card_alpha, card_bravo ]
      Trello::Member.should_receive(:find).at_least(:once).and_return(@member)
    end

    it "puts the cards' name into an array" do
      cards = CardService.all
      cards.count.should eq(2)
      cards.first.name.should eq(@card_alpha_name)
      cards.last.name.should eq(@card_bravo_name)
    end

    it "puts the cards' swimlane into an array" do
      cards = CardService.all
      cards.count.should eq(2)
      cards.first.list_name.should eq(@list_alpha.name)
      cards.last.list_name.should eq(@list_bravo.name)
    end

    it "puts the cards' startdate into an array" do
      cards = CardService.all
      cards.count.should eq(2)
      cards.first.start_date.should eq(@action_create_alpha.date)
      cards.last.start_date.should eq(@action_create_bravo.date)
    end
  end

  context "receives multiple cards from trello, one unhandleable" do
    before do
      @member.boards = [ @first_board ]
      @first_board.lists = [ @list_alpha, @list_bravo ]
      @first_board.actions = [ @action_create_alpha, @action_create_bravo, @action_create_foreign ]
      action_cache = double('action cache')
      actions_that_throws_exception = double('actions throwing exception')
      allow(actions_that_throws_exception).to receive(:count).and_raise('testing exception')
      allow(action_cache).to receive(:actions).and_return(@first_board.actions, @first_board.actions, actions_that_throws_exception)
      ActionCache.stub(:new).and_return(action_cache)
      card_alpha = create_card(@card_alpha_id, @card_alpha_name, @card_alpha_list_id)
      card_bravo = create_card(@card_bravo_id, @card_bravo_name, @card_bravo_list_id)
      card_foreign = create_card(@card_foreign_id, @card_foreign_name, @card_foreign_list_id)
      @first_board.cards = [ card_alpha, card_bravo, card_foreign ]
      Trello::Member.should_receive(:find).at_least(:once).and_return(@member)
    end

    def create_card(id, name, list_id)
      card = OpenStruct.new
      card.id = id
      card.name = name
      card.list_id = list_id
      card
    end

    it "puts the cards' name into an array, discarding the errored card" do
      cards = CardService.all
      cards.count.should eq(2)
      cards.first.name.should eq(@card_alpha_name)
      cards.last.name.should eq(@card_bravo_name)
      cards.should_not include(@card_foreign_name)
    end

    it "puts the cards' swimlane into an array, discarding the errored card" do
      cards = CardService.all
      cards.count.should eq(2)
      cards.first.list_name.should eq(@list_alpha.name)
      cards.last.list_name.should eq(@list_bravo.name)
      cards.should_not include(@list_foreign.name)
    end

    it "puts the cards' startdate into an array, discarding the errored card" do
      cards = CardService.all
      cards.count.should eq(2)
      cards.first.start_date.should eq(@action_create_alpha.date)
      cards.last.start_date.should eq(@action_create_bravo.date)
      cards.should_not include(@action_create_foreign.date)
      cards.should_not include('Error')
    end
  end

  context "receives multiple cards from trello that have multiple actions such as being both created and later moved into the Resumes swimlane" do
    before do
      @first_board.lists = [ @list_alpha, @list_bravo ]
      @first_board.actions = [ @action_update_alpha_latest, @action_update_alpha, @action_update_bravo, @action_create_bravo ]
      action_cache = OpenStruct.new
      action_cache.actions = @first_board.actions
      ActionCache.should_receive(:new).at_least(:once).and_return(action_cache)
      card_bravo = Card.new(CardService.create_list_id_to_name(@first_board), @card_bravo_name, @card_bravo_id, @card_bravo_list_id, action_cache.actions)
      card_alpha = Card.new(CardService.create_list_id_to_name(@first_board), @card_alpha_name, @card_alpha_id, @card_alpha_list_id, action_cache.actions)
      @first_board.cards = [ card_alpha, card_bravo ]
      @member.boards = [ @first_board ]
      Trello::Member.should_receive(:find).at_least(:once).and_return(@member)
    end

    it "puts the cards' startdates into an array, using the latest movement into the Resumes swimlane as the start date for alpha, and the creation date of the card for bravo" do
      cards = CardService.all
      cards.count.should eq(2)
      cards.first.start_date.should eq(@action_update_alpha_latest.date)
      cards.last.start_date.should eq(@action_create_bravo.date)
    end
  end

  context "receives no cards from trello" do
    before do
      @first_board.cards = [ ]
      @member.boards = [ @first_board ]
      Trello::Member.should_receive(:find).at_least(:once).and_return(@member)
      action_cache = OpenStruct.new
      action_cache.actions = []
      ActionCache.should_receive(:new).at_least(:once).and_return(action_cache)
    end

  it "puts nothing into an array" do
    cards = CardService.all
    cards.count.should eq(0)
    end
  end
end