require 'rspec'
require 'spec_helper'
require 'trello'

describe ActiveFilterService do
  context 'there are no cards and show_only is set to inactive_cards' do
    it 'returns an empty array' do
      cards = [ ]
      ActiveFilterService.filter_show_inactive_cards(cards).should eq([ ])
    end
  end

  context 'there is one active card and one inactive card and show_only is set to active_cards' do
    it 'returns the active card' do
      active_card = OpenStruct.new(:is_active? => true)
      inactive_card = OpenStruct.new
      cards = [ active_card, inactive_card ]
      ActiveFilterService.filter_show_active_cards(cards).should eq([ active_card ])
    end
  end

  context 'there is one active card and one inactive card and show_only is set to inactive_cards' do
    it 'returns the inactive card' do
      active_card = OpenStruct.new(:is_active? => true)
      inactive_card = OpenStruct.new
      cards = [ active_card, inactive_card ]
      ActiveFilterService.filter_show_inactive_cards(cards).should eq([ inactive_card ])
    end
  end
end