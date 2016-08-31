require 'rspec'
require 'spec_helper'
require 'trello'

describe CardService do
  before do
    @list_alpha = List.new('1', 'Alphas List')
    @list_bravo = List.new('2', 'Bravos List')

    @action_create_alpha = Action.new('createCard', '1', '1/1/1991')
    @action_update_alpha = Action.new('updateCard', '1', '1/1/2001')
    @action_update_alpha_latest = Action.new('updateCard', '1', '1/1/2011')
    @action_create_bravo = Action.new('createCard', '2', '1/1/1992')
    @action_update_bravo = Action.new('updateCard', '2', '1/1/2002')
    @action_update_bravo_latest = Action.new('updateCard', '2', '1/1/2012')

    @first_board = Board.new
    @member = Member.new
  end

  context "receives a card from trello that was created in the Resumes swimlane" do
    before do
      @first_board.lists = [ @list_alpha ]
      @first_board.actions = [ @action_create_alpha ]
      @card_alpha = Card.new(@first_board, 'Alpha', '1', '1')
      @first_board.cards = [ @card_alpha ]
      @member.boards = [ @first_board ]
      Trello::Member.should_receive(:find).and_return(@member)
    end

    it "puts the card's names into an array" do
      cards = CardService.all
      cards.count.should eq(1)
      cards.first.name.should eq(@card_alpha.name)
    end

    it "puts the card's swimlanes into an array" do
      cards = CardService.all
      cards.count.should eq(1)
      cards.first.list_name.should eq(@card_alpha.list_name)
    end

    it "puts the card's creation dates into an array" do
      cards = CardService.all
      cards.count.should eq(1)
      cards.first.start_date.should eq(@action_create_alpha.date)
    end
  end

  context "receives a card from trello of a card that was moved in to the Resumes to be Screened swimlane" do
    before do
      @first_board.lists = [ @list_bravo ]
      @first_board.actions = [ @action_update_bravo_latest, @action_update_bravo ]
      @card_bravo = Card.new(@first_board, 'Bravo', '2', '2')
      @first_board.cards = [ @card_bravo ]
      @member.boards = [ @first_board ]
      Trello::Member.should_receive(:find).and_return(@member)
    end

    it "puts the card's name into an array" do
      cards = CardService.all
      cards.count.should eq(1)
      cards.first.name.should eq(@card_bravo.name)
    end

    it "puts the card's swimlane into an array" do
      cards = CardService.all
      cards.count.should eq(1)
      cards.first.list_name.should eq(@card_bravo.list_name)
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
      @first_board.actions = [ ]
      @card_bravo = Card.new(@first_board, 'Bravo', '2', '2')
      @first_board.cards = [ @card_bravo ]
      @member.boards = [ @first_board ]
      Trello::Member.should_receive(:find).and_return(@member)
    end

    it "puts a warning to the user in place of the startdate" do
      cards = CardService.all
      cards.count.should eq(1)
      cards.first.start_date.should eq('This card has never been placed in the Resumes to be Screened lane.')
    end
  end

  context "receives multiple cards from trello that were created in the Resumes swimlane" do
    before do
      @member.boards = [ @first_board ]
      @first_board.lists = [ @list_alpha, @list_bravo ]
      @first_board.actions = [ @action_create_alpha, @action_create_bravo ]
      @card_bravo = Card.new(@first_board, 'Bravo', '2', '2')
      @card_alpha = Card.new(@first_board, 'Alpha', '1', '1')
      @first_board.cards = [ @card_alpha, @card_bravo ]
      Trello::Member.should_receive(:find).and_return(@member)
    end

    it "puts the cards' name into an array" do
      cards = CardService.all
      cards.count.should eq(2)
      cards.first.name.should eq(@card_alpha.name)
      cards.last.name.should eq(@card_bravo.name)
    end

    it "puts the cards' swimlane into an array" do
      cards = CardService.all
      cards.count.should eq(2)
      cards.first.list_name.should eq(@card_alpha.list_name)
      cards.last.list_name.should eq(@card_bravo.list_name)
    end

    it "puts the cards' startdate into an array" do
      cards = CardService.all
      cards.count.should eq(2)
      cards.first.start_date.should eq(@action_create_alpha.date)
      cards.last.start_date.should eq(@action_create_bravo.date)
    end
  end

  context "receives multiple cards from trello that have multiple actions such as being both created and later moved into the Resumes swimlane" do
    before do
      @first_board.lists = [ @list_alpha, @list_bravo ]
      @first_board.actions = [ @action_update_alpha_latest, @action_update_alpha, @action_update_bravo, @action_create_bravo ]
      @card_bravo = Card.new(@first_board, 'Bravo', '2', '2')
      @card_alpha = Card.new(@first_board, 'Alpha', '1', '1')
      @first_board.cards = [ @card_alpha, @card_bravo ]
      @member.boards = [ @first_board ]
      Trello::Member.should_receive(:find).and_return(@member)
    end

    it "puts the cards' names into an array" do
      cards = CardService.all
      cards.count.should eq(2)
      cards.first.name.should eq(@card_alpha.name)
      cards.last.name.should eq(@card_bravo.name)
    end

    it "puts the cards' swimlanes into an array" do
      cards = CardService.all
      cards.count.should eq(2)
      cards.first.list_name.should eq(@card_alpha.list_name)
      cards.last.list_name.should eq(@card_bravo.list_name)
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
      Trello::Member.should_receive(:find).and_return(@member)
    end

  it "puts nothing into an array" do
    cards = CardService.all
    cards.count.should eq(0)
    end
  end
end