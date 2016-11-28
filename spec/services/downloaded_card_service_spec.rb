require 'rspec'
require 'spec_helper'

describe DownloadedCardService do
  before do
    @card_one = DownloadedCard.new(name: 'Michael')
    card_two = DownloadedCard.new(name: 'Ricky')
    card_three = DownloadedCard.new(name: 'Mario')
    @cards = [@card_one, card_two, card_three]
  end

  context 'if the card doesnt exist, create it' do
    it 'with no cards, it saves nothing' do
      @cards = []
      DownloadedCardService.save_cards(@cards)
      DownloadedCard.all.count.should eq(0)
    end

    it 'with one card, saves a card' do
      @cards = [@card_one]
      DownloadedCardService.save_cards(@cards)
      DownloadedCard.all.count.should eq(1)
      DownloadedCard.first.name.should eq('Michael')
    end

    it 'with multiple cards, iterates through the array and saves each card' do
      DownloadedCardService.save_cards(@cards)
      DownloadedCard.all.count.should eq(3)
      DownloadedCard.third.name.should eq('Mario')
    end
  end
end
