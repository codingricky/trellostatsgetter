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

  subject { CardService.all }



  context 'invalid config' do
    it 'raises an error when the member is not found' do
      Trello::Member.should_receive(:find).at_least(:once).and_return(nil)
      expect{ subject }.to raise_error(RuntimeError)
    end

    it 'raises an error when the board is not found' do
      member = Member.new
      member.boards = []
      Trello::Member.should_receive(:find).at_least(:once).and_return(member)
      expect{ subject }.to raise_error(RuntimeError)
    end
  end

  context 'a card that has been created but has not finished' do
    before do
      member = Member.new
      @list = List.new(100, 'Alphas List')
      @card = OpenStruct.new(id: 1, name: 'test card', list_id: @list.id)
      @create_action = Action.new('createCard', @card.id, '1/1/1991')

      Trello::Member.stub(:find).and_return(member)

      board = Board.new
      member.boards = [board]
      board.lists = [@list]
      board.cards = [@card]

      ActionCache.stub(:new).and_return(OpenStruct.new(actions: [@create_action]))
    end

    it 'should return the correct name' do
      subject.first.name.should eq(@card.name)
    end

    it 'should return the correct number of cards' do
      subject.count.should eql(1)
    end

    it 'should return the correct list name' do
      subject.first.list_name.should eql(@list.name)
    end

    it 'should set the start date' do
      subject.first.start_date.should eql(@create_action.date)
    end

    it 'should set the end date to nil' do
      subject.first.end_date.should be_nil
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