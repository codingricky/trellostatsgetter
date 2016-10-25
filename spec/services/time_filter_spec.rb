require 'rspec'
require 'spec_helper'
require 'trello'

describe TimeFilterService do
  before do
    @remaining_card = OpenStruct.new
    @remaining_card.start_date = (Date.today - 1).to_time
    card_to_be_filtered = OpenStruct.new
    card_to_be_filtered.start_date = (Date.today - 3).to_time
    another_card_to_be_filtered = OpenStruct.new
    another_card_to_be_filtered.start_date = nil
    @cards = [ @remaining_card, card_to_be_filtered, another_card_to_be_filtered ]
  end

 it "removes cards older than the value of days_ago" do
   @cards.count.should eq(3)
   CardService.stub(:all).and_return(@cards)
   days_ago = 2
   filtered_cards = TimeFilterService.filter_cards(days_ago)
   filtered_cards.count.should eq(1)
   filtered_cards.first.should eq(@remaining_card)
 end
end