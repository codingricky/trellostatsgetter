require 'rspec'
require 'spec_helper'
require 'trello'

describe CardService do
  before do
    @member = Member.new
    @starting_list = List.new(101, CardService::STARTING_LANE)
    @finished_list = List.new(100, CardService::FINISHING_LANES.first)
    @finished_card = OpenStruct.new(id: 1, name: 'test card', list_id: @finished_list.id)

    @finished_card_create_action = Action.new('createCard', @finished_card.id, '1/1/1991')
    @finished_card_end_action = Action.new('updateCard_finish', @finished_card.id, '2/1/1991')

    @card_still_in_progress = OpenStruct.new(id: 2, name: 'test card', list_id: @starting_list.id)
    @card_still_in_progress_create_action = Action.new('createCard', @card_still_in_progress.id, '1/1/1991')

    Trello::Member.stub(:find).and_return(@member)

    @board = Board.new
    @member.boards = [@board]
    @board.lists = [@starting_list, @finished_list]
    @board.cards = [@card_still_in_progress, @finished_card]

    ActionCache.stub(:new).and_return(OpenStruct.new(actions: [@finished_card_create_action, @finished_card_end_action, @card_still_in_progress_create_action]))
  end

  subject { CardService.all }

  context 'invalid config' do
    it 'raises an error when the member is not found' do
      Trello::Member.stub(:find).and_return(nil)
      expect { subject }.to raise_error(RuntimeError)
    end

    it 'raises an error when the board is not found' do
      @member.boards = []
      Trello::Member.stub(:find).and_return(@member)
      expect { subject }.to raise_error(RuntimeError)
    end
  end

  context 'a card that has been created but has not finished' do
    before do
      @board.cards = [@card_still_in_progress]
    end

    it 'should return the correct name' do
      subject.first.name.should eq(@card_still_in_progress.name)
    end

    it 'should return the correct number of cards' do
      subject.count.should eql(1)
    end

    it 'should return the correct list name' do
      subject.first.list_name.should eql(@starting_list.name)
    end

    it 'should set the start date' do
      subject.first.start_date.should eql(@card_still_in_progress_create_action.date)
    end

    it 'should set the end date to nil' do
      subject.first.end_date.should be_nil
    end
  end

  context 'a card from trello of a card that was moved in to the finishing swimlane' do
    it 'should set the end date' do
      subject.last.end_date.should eql(@finished_card_end_action.date)
    end
  end

  context 'card that has never been in the Starting swimline' do
    before do
      @card = OpenStruct.new(id: 1, name: 'test card', list_id: @starting_list.id)
      @create_action = Action.new('updateCard_finish', @card.id, '1/1/1991')
      @board.cards = [@card]
      ActionCache.stub(:new).and_return(OpenStruct.new(actions: [@create_action]))
    end

    it 'start date should be nil' do
      subject.first.start_date.should be_nil
    end
  end

  context 'multiple cards' do
    it 'should create the correct number of cards' do
      subject.count.should eql(2)
    end

    it 'cards should have the right list name' do
      subject.first.list_name.should eql(@starting_list.name)
      subject.last.list_name.should eql(@finished_list.name)
    end

    it 'cards should have the right start date' do
      subject.first.start_date.should eql(@card_still_in_progress_create_action.date)
      subject.last.start_date.should eql(@finished_card_create_action.date)
    end
  end

  context 'receives no cards from trello' do
    before do
      @board.cards = []
    end

    it 'should not return anything' do
      subject.should be_empty
    end
  end
end