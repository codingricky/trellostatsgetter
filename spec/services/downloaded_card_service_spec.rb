require 'rspec'
require 'spec_helper'

describe DownloadedCardService do
  before do
    @card_one = OpenStruct.new(name: 'Michael',
                               card_id: '123abc',
                               list_id: 'abc123',
                               list_name: 'Resumes To Be Screened ',
                               start_date: Time.parse('1/1/1991'),
                               end_date: Time.parse('2/1/1991'),
                               url: 'www.dius.com.au')
    card_two = OpenStruct.new(name: 'Ricky', card_id: '2')
    @card_three = OpenStruct.new(name: 'Mario', card_id: '3')
    @cards = [@card_one, card_two, @card_three]
  end

  context 'if the card does not exist, create it -' do
    it 'with no cards, it saves nothing' do
      @cards = []
      TrelloService.stub(:return_new_cards).with((DateTime.civil_from_format :local, 2001), '55ac308c4ae6522bbe90f501').and_return(@cards)
      TrelloService.stub(:return_new_cards).with((DateTime.civil_from_format :local, 2001), '5302d67d65706eef448e5806').and_return([])
      DownloadedCardService.update_cards
      DownloadedCard.all.count.should eq(0)
    end

    it 'with one card, saves a card' do
      @cards = [@card_one]
      TrelloService.stub(:return_new_cards).with((DateTime.civil_from_format :local, 2001), '55ac308c4ae6522bbe90f501').and_return(@cards)
      TrelloService.stub(:return_new_cards).with((DateTime.civil_from_format :local, 2001), '5302d67d65706eef448e5806').and_return([])
      DownloadedCardService.update_cards
      DownloadedCard.all.count.should eq(1)
      DownloadedCard.first.sanitized_name.should eq(@card_one.name)
      DownloadedCard.first.card_id.should eq(@card_one.card_id)
      DownloadedCard.first.list_id.should eq(@card_one.list_id)
      DownloadedCard.first.list_name.should eq(@card_one.list_name)
      DownloadedCard.first.start_date.should eq(@card_one.start_date)
      DownloadedCard.first.end_date.should eq(@card_one.end_date)
      DownloadedCard.first.url.should eq(@card_one.url)
      DownloadedCard.first.location.should eq('Sydney - Software Engineers')
    end

    it 'with multiple cards, iterates through the array and saves each card' do
      TrelloService.stub(:return_new_cards).with((DateTime.civil_from_format :local, 2001), '55ac308c4ae6522bbe90f501').and_return(@cards)
      TrelloService.stub(:return_new_cards).with((DateTime.civil_from_format :local, 2001), '5302d67d65706eef448e5806').and_return([])
      DownloadedCardService.update_cards
      DownloadedCard.all.count.should eq(3)
      DownloadedCard.third.sanitized_name.should eq(@card_three.name)
    end
  end

  context 'update cards - ' do
    it 'has never been run before, creates a LastUpdatedTime object' do
      TrelloService.stub(:return_new_cards).with((DateTime.civil_from_format :local, 2001), '55ac308c4ae6522bbe90f501').and_return([])
      TrelloService.stub(:return_new_cards).with((DateTime.civil_from_format :local, 2001), '5302d67d65706eef448e5806').and_return([])
      DownloadedCardService.update_cards
      LastUpdatedTime.first.should be_present
    end

    it 'updates LastUpdatedTime' do
      TrelloService.stub(:return_new_cards).with((DateTime.civil_from_format :local, 2001), '55ac308c4ae6522bbe90f501').and_return([])
      TrelloService.stub(:return_new_cards).with((DateTime.civil_from_format :local, 2001), '5302d67d65706eef448e5806').and_return([])
      DownloadedCardService.update_cards
      time = DateTime.current
      DateTime.stub(:current).and_return(time)
      LastUpdatedTime.first.time.to_i.should eq(time.to_i)
    end

    it 'Trello returns two cards, saves cards to the db' do
      @cards = [@card_one, @card_three]
      LastUpdatedTime.create!(time: (DateTime.civil_from_format :local, 2001))
      TrelloService.stub(:return_new_cards).with((LastUpdatedTime.first.time), '55ac308c4ae6522bbe90f501').and_return(@cards)
      TrelloService.stub(:return_new_cards).with((LastUpdatedTime.first.time), '5302d67d65706eef448e5806').and_return([])
      DownloadedCardService.update_cards
      DownloadedCard.all.count.should eq(2)
    end

    it 'Trello returns one card from each board, saves cards to the db' do
      @syd_cards = [@card_one]
      @mel_cards = [@card_three]
      LastUpdatedTime.create!(time: (DateTime.civil_from_format :local, 2001))
      TrelloService.stub(:return_new_cards).with((LastUpdatedTime.first.time), '55ac308c4ae6522bbe90f501').and_return(@syd_cards)
      TrelloService.stub(:return_new_cards).with((LastUpdatedTime.first.time), '5302d67d65706eef448e5806').and_return(@mel_cards)
      DownloadedCardService.update_cards
      DownloadedCard.all.count.should eq(2)
    end

    it 'card already exists, updates the fields of the card' do
      @syd_cards = [@card_one]
      card = DownloadedCard.new(card_id: @card_one.card_id, sanitized_name: @card_one.name, location: 'Sydney - Software Engineers')
      card.save!
      LastUpdatedTime.create!(time: (DateTime.civil_from_format :local, 2001))
      TrelloService.stub(:return_new_cards).with((LastUpdatedTime.first.time), '55ac308c4ae6522bbe90f501').and_return(@syd_cards)
      TrelloService.stub(:return_new_cards).with((LastUpdatedTime.first.time), '5302d67d65706eef448e5806').and_return([])
      DownloadedCardService.update_cards
      DownloadedCard.all.count.should eq(1)
    end
  end
end

