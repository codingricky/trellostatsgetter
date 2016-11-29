require 'rspec'
require 'spec_helper'
require 'trello'

describe TimeFilterService do

  let(:days_old) { 200 }
  let(:location) { 'Name of Selected Location Here' }
  let(:show_only) { 'all_cards' }
  subject { TimeFilterService.filter_cards(days_old, location, show_only) }

  before do
    @old_card = OpenStruct.new(sanitized_name: 'Old card', start_date: (Date.today - days_old - 1).to_time)
    @second_old_card = OpenStruct.new(sanitized_name: 'Second old card', start_date: (Date.today - days_old - 1).to_time)

    @young_card = OpenStruct.new(sanitized_name: 'Young card', start_date: (Date.today - days_old + 1).to_time)
    @second_young_card = OpenStruct.new(sanitized_name: 'Second young card', start_date: (Date.today - days_old + 1).to_time)
  end

  it 'should return one card that has been created recently' do
    CardService.stub(:all).and_return([@young_card])

    subject.count.should eq(1)
    subject.first.sanitized_name.should eq(@young_card.sanitized_name)
  end

  it 'should return multiple cards that have been created recently' do
    CardService.stub(:all).and_return([@young_card, @second_young_card])

    subject.count.should eq(2)
  end

  context 'should not return a card(s)' do
    it 'that is older than our filter' do
      CardService.stub(:all).and_return([@old_card])

      subject.should be_empty
    end

    it 'that are older than our filter' do
      CardService.stub(:all).and_return([@old_card, @second_old_card])

      subject.should be_empty
    end

    it 'that is older than our filter, but should return a card that is younger' do
      CardService.stub(:all).and_return([@old_card, @young_card])

      subject.count.should eq(1)
      subject.first.sanitized_name.should eq(@young_card.sanitized_name)
    end

    it 'that are older than our filter, but should return cards that are younger' do
      CardService.stub(:all).and_return([@old_card, @young_card, @second_old_card, @second_young_card])

      subject.count.should eq(2)
      subject.first.sanitized_name.should eq(@young_card.sanitized_name)
      subject.last.sanitized_name.should eq(@second_young_card.sanitized_name)
    end

    it 'with invalid start dates' do
      nil_start_date_card = OpenStruct.new(start_date: nil)
      CardService.stub(:all).and_return([@young_card, nil_start_date_card])

      subject.count.should eq(1)
      subject.first.sanitized_name.should eq(@young_card.sanitized_name)
    end
  end

  it 'parses location through to card service' do
    expect(CardService).to receive(:all).with('Name of Selected Location Here')
    CardService.stub(:all).and_return([])
    subject
  end

  it 'does not parse show_only through to active filter' do
    expect(ActiveFilterService).not_to receive(:filter_show_active_cards).with([])
    expect(ActiveFilterService).not_to receive(:filter_show_inactive_cards).with([])
    CardService.stub(:all).and_return([])
    TimeFilterService.filter_cards('200', 'Location name', 'all_cards')
  end

  it 'parses show_only active through to active filter' do
    expect(ActiveFilterService).to receive(:filter_show_active_cards).with([])
    CardService.stub(:all).and_return([])
    TimeFilterService.filter_cards('200', 'Location name', 'active_cards')
  end

  it 'parses show_only inactive through to active filter' do
    expect(ActiveFilterService).to receive(:filter_show_inactive_cards).with([])
    CardService.stub(:all).and_return([])
    TimeFilterService.filter_cards('200', 'Location name', 'inactive_cards')
  end
end