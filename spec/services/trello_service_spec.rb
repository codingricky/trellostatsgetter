require 'rspec'
require 'spec_helper'
require 'trello'

describe TrelloService do
  before do
    ConfigService.stub(:starting_lanes).and_return(['starting', 'another starting lane'])
    ConfigService.stub(:finishing_lanes).and_return(['finishing', 'another finishing lane'])
    ConfigService.stub(:source_names).and_return(['source'])

    @member = OpenStruct.new
    @starting_list = OpenStruct.new(id:'101', name:ConfigService.starting_lanes.first)
    @finished_list = OpenStruct.new(id:'100', name:ConfigService.finishing_lanes.first)
    @finished_card = OpenStruct.new(id: '1', name: 'test card', list_id: @finished_list.id)
    @old_finished_list = OpenStruct.new(id:'102', name:ConfigService.finishing_lanes.last)
    @old_finished_card = OpenStruct.new(id: '3', name: 'old test card', list_id: @old_finished_list.id)

    @finished_card_create_action = OpenStruct.new(type:'createCard', date:Time.parse('1/1/1991'), data:{'list' =>{'name' => ConfigService.starting_lanes.first},
                                                                                                         'card' =>
                                                                                                             {'id' => @finished_card.id}})
    @finished_card_end_action = OpenStruct.new(type:'updateCard', date:Time.parse('2/1/1991'), data:{'listAfter' =>{'name' => ConfigService.finishing_lanes.first},
                                                                                                      'card' =>
                                                                                                          {'id' =>@finished_card.id}})

    @old_finished_card_create_action = OpenStruct.new(type:'createCard', date:Time.parse('3/2/1991'), data:{'list' =>{'name' => ConfigService.starting_lanes.first},
                                                                                                              'card' =>
                                                                                                                  {'id' => @old_finished_card.id}})
    @old_finished_card_end_action = OpenStruct.new(type:'updateCard', date:Time.parse('4/2/1991'), data:{'listAfter' =>{'name' => ConfigService.finishing_lanes.first},
                                                                                                                     'card' =>
                                                                                                                         {'id' =>@old_finished_card.id}})

    @card_still_in_progress = OpenStruct.new(id: '2', name: 'test card', list_id: @starting_list.id, url: 'www.test.com')
    @card_still_in_progress_create_action = OpenStruct.new(type:'createCard', date:Time.parse('1/1/1991'), data:{'list' =>{'name' => ConfigService.starting_lanes.first},
                                                                                                                  'card' =>
                                                                                                                      {'id' => @card_still_in_progress.id}})
    @card_still_in_progress_attachment_action = OpenStruct.new(type:'addAttachmentToCard', date:Time.parse('1/1/1991'), data: {'attachment' =>{'name' => 'Resume_Valid Source.pdf'},
                                                                                                                                 'card' =>
                                                                                                                                     {'id' => @card_still_in_progress.id}})

    Trello::Member.stub(:find).and_return(@member)

    @board = OpenStruct.new
    @board.name = 'Sydney - Software Engineers'
    @board.id = '55ac308c4ae6522bbe90f501'
    @board.lists = [@starting_list, @finished_list, @old_finished_list]
    @board.cards = [@card_still_in_progress, @finished_card]

    @wrong_board = OpenStruct.new
    @wrong_board.name = 'Melbourne Recruitment Pipeline'
    @wrong_board.id = '5302d67d65706eef448e5806'
    @wrong_board.lists = [@starting_list, @finished_list, @old_finished_list]
    @wrong_board.cards = [@old_finished_card]

    @member.boards = [@board]

    ActionService.stub(:get_actions).and_return([@finished_card_create_action, @finished_card_end_action, @card_still_in_progress_create_action, @card_still_in_progress_attachment_action, @old_finished_card_create_action, @old_finished_card_end_action])
    TrelloService.stub(:get_trello_cards_with_changes).with(any_args).and_return(@member.boards.first.cards)
  end

  subject { TrelloService.return_new_cards((DateTime.civil_from_format :local, 1975), '55ac308c4ae6522bbe90f501') }

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
      @member.boards = [@board, @wrong_board]
      Trello::Member.stub(:find).and_return(@member)
      subject.count.should eql(2)
      subject.first.card_id.should eql('2')
      subject.second.card_id.should eql('1')
    end
  end

  context 'a card that has been created but has not finished' do
    before do
      TrelloService.stub(:get_trello_cards_with_changes).with(any_args).and_return([@card_still_in_progress])
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

    it 'should set the correct url' do
      subject.first.url.should eql('www.test.com')
    end
  end

  context 'a card from trello that was moved in to the finishing swimlane' do
    it 'should set the end date' do
      subject.last.end_date.should eql(@finished_card_end_action.date)
    end
  end

  context 'a card from trello that was moved in to an old finishing swimlane' do
    it 'should set the end date' do
      TrelloService.stub(:get_trello_cards_with_changes).with(any_args).and_return([@old_finished_card])
      subject.last.end_date.should eql(@old_finished_card_end_action.date)
    end
  end

  context 'card that has never been in the Starting swimlane' do
    before do
      @card = OpenStruct.new(id: '1', name: 'test card', list_id: @starting_list.id)
      @create_action = OpenStruct.new(type:'createCard', date:Time.parse('1/1/1991'), data:{'list' =>{'name' => ConfigService.finishing_lanes.first},
                                                                                            'card' =>
                                                                                                {'id' =>@card.id}})
      TrelloService.stub(:get_trello_cards_with_changes).with(any_args).and_return([@card])
      ActionService.stub(:get_actions).and_return([@create_action])
    end

    it 'start date should be nil' do
      subject.first.start_date.should be_nil
    end
  end

  context 'a card from trello that was copied in to the Starting swimlane' do
    before do
      @card = OpenStruct.new(id: '1', name: 'test card', list_id: @starting_list.id)
      @create_action = OpenStruct.new(type:'copyCard', date:Time.parse('1/1/1991'), data:{'list' =>{'name' => ConfigService.starting_lanes.first},
                                                                                           'card' =>
                                                                                               {'id' =>@card.id}})
      TrelloService.stub(:get_trello_cards_with_changes).with(any_args).and_return([@card])
      ActionService.stub(:get_actions).and_return([@create_action])
    end

    it 'should set the start date' do
      subject.first.start_date.should eq(Time.parse('1/1/1991'))
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
      TrelloService.stub(:get_trello_cards_with_changes).with(any_args).and_return([])
    end

    it 'should not return anything' do
      subject.should be_empty
    end
  end

  context 'receives a card from trello with no attachments' do
    before do
      TrelloService.stub(:get_trello_cards_with_changes).with(any_args).and_return([@finished_card])
    end

    it 'returns an empty array' do
      subject.first.attachments.should eql([])
    end
  end

  context 'receives a card from trello with an attachment' do
    before do
      TrelloService.stub(:get_trello_cards_with_changes).with(any_args).and_return([@card_still_in_progress])
    end

    it 'retrieves the attachment names and puts them in an array' do
      subject.first.attachments.should eql([ @card_still_in_progress_attachment_action.data['attachment']['name'] ])
    end
  end

  it 'finds the difference in days between now and the day since the last update was run' do
    expect(TrelloService).to receive(:get_trello_cards_with_changes).with('55ac308c4ae6522bbe90f501', 2)
    TrelloService.return_new_cards((DateTime.yesterday), '55ac308c4ae6522bbe90f501')
  end

  it 'returns an empty array without continuing if there are no recently changed cards' do
    TrelloService.stub(:get_trello_cards_with_changes).with(any_args).and_return([])
    expect(TrelloService).to receive(:get_trello_cards_with_changes).once.with('55ac308c4ae6522bbe90f501', 1)
    TrelloService.return_new_cards((DateTime.now), '55ac308c4ae6522bbe90f501').should eq([])
  end
end