require 'rspec'
require 'spec_helper'
require 'trello'

describe TrelloCard do
  BOARD_ID = '123'

  before do
    ConfigService.stub(:starting_lanes).and_return(['starting', 'another starting lane'])
    ConfigService.stub(:finishing_lanes).and_return(['finishing', 'another finishing lane'])
    ConfigService.stub(:source_names).and_return(['source'])

    @member = OpenStruct.new
    @starting_list = OpenStruct.new(id: '101', name: ConfigService.starting_lanes.first)
    @finished_list = OpenStruct.new(id: '100', name: ConfigService.finishing_lanes.first)
    @finished_card = OpenStruct.new(id: '1', name: 'test card', list_id: @finished_list.id)
    @old_finished_list = OpenStruct.new(id: '102', name: ConfigService.finishing_lanes.last)
    @old_finished_card = OpenStruct.new(id: '3', name: 'old test card', list_id: @old_finished_list.id)

    @finished_card_create_action = OpenStruct.new(type: 'createCard', date: Time.parse('1/1/1991'), data: {'list' => {'name' => ConfigService.starting_lanes.first},
                                                                                                           'card' =>
                                                                                                               {'id' => @finished_card.id}})
    @finished_card_end_action = OpenStruct.new(type: 'updateCard', date: Time.parse('2/1/1991'), data: {'listAfter' => {'name' => ConfigService.finishing_lanes.first},
                                                                                                        'card' =>
                                                                                                            {'id' => @finished_card.id}})

    @old_finished_card_create_action = OpenStruct.new(type: 'createCard', date: Time.parse('3/2/1991'), data: {'list' => {'name' => ConfigService.starting_lanes.first},
                                                                                                               'card' =>
                                                                                                                   {'id' => @old_finished_card.id}})
    @old_finished_card_end_action = OpenStruct.new(type: 'updateCard', date: Time.parse('4/2/1991'), data: {'listAfter' => {'name' => ConfigService.finishing_lanes.first},
                                                                                                            'card' =>
                                                                                                                {'id' => @old_finished_card.id}})

    @card_still_in_progress = OpenStruct.new(id: '2', name: 'test card', list_id: @starting_list.id, url: 'www.test.com')
    @card_still_in_progress_create_action = OpenStruct.new(type: 'createCard', date: Time.parse('1/1/1991'), data: {'list' => {'name' => ConfigService.starting_lanes.first},
                                                                                                                    'card' =>
                                                                                                                        {'id' => @card_still_in_progress.id}})
    @card_still_in_progress_attachment_action = OpenStruct.new(type: 'addAttachmentToCard', date: Time.parse('1/1/1991'), data: {'attachment' => {'name' => 'Resume_Valid Source.pdf'},
                                                                                                                                 'card' =>
                                                                                                                                     {'id' => @card_still_in_progress.id}})

    Trello::Member.stub(:find).and_return(@member)

    @board = OpenStruct.new
    @board.name = 'Sydney - Software Engineers'
    @board.id = BOARD_ID
    @board.lists = [@starting_list, @finished_list, @old_finished_list]
    @board.cards = [@card_still_in_progress, @finished_card]

    @actions = [@finished_card_create_action, @finished_card_end_action, @card_still_in_progress_create_action, @card_still_in_progress_attachment_action, @old_finished_card_create_action, @old_finished_card_end_action]
  end

  context 'a card that has been created but has not finished' do
    before do
      @card = TrelloCard.new(@card_still_in_progress, @actions, @starting_list.name)
    end

    it 'should return the correct name' do
      @card.name.should eq(@card_still_in_progress.name)
    end

    it 'should return the correct list name' do
      @card.list_name.should eql(@starting_list.name)
    end

    it 'should set the start date' do
      @card.start_date.should eql(@card_still_in_progress_create_action.date)
    end

    it 'should set the end date to nil' do
      @card.end_date.should be_nil
    end

    it 'should set the correct url' do
      @card.url.should eql('www.test.com')
    end

    it 'should set the actions' do
      @card.actions.should_not be_nil
    end

  end

  context 'a card from trello that was moved in to the finishing swimlane' do
    before do
      @card = TrelloCard.new(@finished_card, [@finished_card_end_action], ConfigService.finishing_lanes.first)
    end

    it 'should set the end date' do
      @card.end_date.should eql(@finished_card_end_action.date)
    end
  end

  context 'a card from trello that was moved in to an old finishing swimlane' do
    before do
      @card = TrelloCard.new(@old_finished_card, [@old_finished_card_end_action],  ConfigService.finishing_lanes.first)
    end

    it 'should set the end date' do
      @card.end_date.should eql(@old_finished_card_end_action.date)
    end
  end

  context 'card that has never been in the Starting swimlane' do
    before do
      @card = OpenStruct.new(id: '1', name: 'test card', list_id: @starting_list.id)
      @create_action = OpenStruct.new(type: 'createCard', date: Time.parse('1/1/1991'), data: {'list' => {'name' => ConfigService.finishing_lanes.first},
                                                                                               'card' =>
                                                                                                   {'id' => @card.id}})

      @card = TrelloCard.new(@card_still_in_progress, [@create_action], @starting_list.name)

    end

    it 'start date should be nil' do
      @card.start_date.should be_nil
    end
  end

  context 'a card from trello that was copied in to the Starting swimlane' do
    before do
      created_card = OpenStruct.new(id: '1', name: 'test card', list_id: @starting_list.id)
      @create_action = OpenStruct.new(type: 'copyCard', date: Time.parse('1/1/1991'), data: {'list' => {'name' => ConfigService.starting_lanes.first},
                                                                                             'card' =>
                                                                                                 {'id' => created_card.id}})
      @card = TrelloCard.new(created_card, [@create_action], ConfigService.starting_lanes.first)
    end

    it 'should set the start date' do
      @card.start_date.should eql(Time.parse('1/1/1991'))
    end
  end


  context 'receives a card from trello with no attachments' do
    before do
      @card = TrelloCard.new(@card_still_in_progress, [@finished_card_create_action], @starting_list.name)
    end

    it 'returns an empty array' do
      @card.attachments.should be_empty
    end
  end

  context 'receives a card from trello with an attachment' do
    before do
      @card = TrelloCard.new(@card_still_in_progress, [@card_still_in_progress_attachment_action], @starting_list.name)
    end

    it 'retrieves the attachment names and puts them in an array' do
      @card.attachments.should eql([@card_still_in_progress_attachment_action.data['attachment']['name']])
    end
  end
end