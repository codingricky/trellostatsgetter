require 'rspec'
require 'spec_helper'

describe DownloadedCardService do
  before do
    @card_one = Card.new(name: 'Michael',
                        id: '123abc',
                        list_id: 'abc123',
                        list_name: 'Resumes To Be Screened ',
                        start_date: (DateTime.now - 1),
                        end_date: (DateTime.now),
                        url: 'www.dius.com.au')
    card_two = Card.new(name: 'Ricky', card_id: '2')
    @card_three = Card.new(name: 'Mario', card_id: '3')
    @cards = [@card_one, card_two, @card_three]
  end

  context 'if the card does not exist, create it -' do
    it 'with no cards, it saves nothing' do
      @cards = []
      DownloadedCardService.save_cards(@cards)
      DownloadedCard.all.count.should eq(0)
    end

    it 'with one card, saves a card' do
      @cards = [@card_one]
      DownloadedCardService.save_cards(@cards)
      DownloadedCard.all.count.should eq(1)
      DownloadedCard.first.sanitized_name.should eq(@card_one.name)
      DownloadedCard.first.card_id.should eq(@card_one.id)
      DownloadedCard.first.list_id.should eq(@card_one.list_id)
      DownloadedCard.first.list_name.should eq(@card_one.list_name)
      DownloadedCard.first.start_date.should eq(@card_one.start_date)
      DownloadedCard.first.end_date.should eq(@card_one.end_date)
      DownloadedCard.first.url.should eq(@card_one.url)
    end

    it 'with multiple cards, iterates through the array and saves each card' do
      DownloadedCardService.save_cards(@cards)
      DownloadedCard.all.count.should eq(3)
      DownloadedCard.third.sanitized_name.should eq(@card_three.name)
    end
  end

  context 'database has cards already stored -' do
    before do
      DownloadedCard.create(sanitized_name: 'dud1')
      DownloadedCard.create(sanitized_name: 'dud2')
    end

    it 'clears the database before use' do
      @cards = []
      DownloadedCardService.save_cards(@cards)
      DownloadedCard.all.count.should eq(0)
    end
  end

  it 'returns an array of downloaded cards' do
    @cards = [@card_one]
    result = DownloadedCardService.save_cards(@cards)
    result.is_a?(Array).should eq(TRUE)
    result.first.is_a?(DownloadedCard).should eq(TRUE)
  end
end

