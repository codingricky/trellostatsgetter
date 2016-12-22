require 'rspec'
require 'spec_helper'
require 'trello'

describe TrelloService do
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

    @other_board = OpenStruct.new
    @other_board.name = 'Melbourne Recruitment Pipeline'
    @other_board.id = '2'
    @other_board.lists = [@starting_list, @finished_list, @old_finished_list]
    @other_board.cards = [@old_finished_card]

    @member.boards = [@board]

    ActionService.stub(:get_actions).and_return([@finished_card_create_action, @finished_card_end_action, @card_still_in_progress_create_action, @card_still_in_progress_attachment_action, @old_finished_card_create_action, @old_finished_card_end_action])
    # TODO shouldn't stub the class under test
    TrelloService.stub(:get_trello_cards_with_changes).with(any_args).and_return(@board.cards)
  end

  subject { TrelloService.return_new_cards((DateTime.civil_from_format :local, 1975), BOARD_ID) }

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

  context 'two boards on Trello' do
    it 'only gets the cards from the board specified by location' do
      @member.boards = [@board, @other_board]
      Trello::Member.stub(:find).and_return(@member)
      subject.count.should eql(2)
      subject.first.card_id.should eql('2')
      subject.second.card_id.should eql('1')
    end
  end

  it 'returns an empty array without continuing if there are no recently changed cards' do
    TrelloService.stub(:get_trello_cards_with_changes).with(any_args).and_return([])
    expect(TrelloService).to receive(:get_trello_cards_with_changes).once.with(BOARD_ID, 1)
    TrelloService.return_new_cards((DateTime.now), BOARD_ID).should eq([])
  end
end