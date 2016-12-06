require 'rspec'
require 'spec_helper'
require 'trello'

describe TimeFilterService do

  let(:days_old) { 200 }
  let(:location) { 'Sydney' }
  let(:show_only) { 'all_cards' }
  subject { TimeFilterService.filter_cards(days_old, location, show_only) }

  before do
    ConfigService.stub(:source_names).and_return(['source'])

    @old_card = create(:downloaded_card, start_date: (Date.today - days_old - 1).to_time)
    @second_old_card = create(:downloaded_card, start_date: (Date.today - days_old - 1).to_time)

    @young_card = create(:downloaded_card, start_date: (Date.today - days_old + 1).to_time)
    @second_young_card = create(:downloaded_card, start_date: (Date.today - days_old + 1).to_time)
  end

  it 'should return one card that has been created recently' do
    DownloadedCard.stub(:all).and_return([@young_card])

    subject.count.should eq(1)
    subject.first.sanitized_name.should eq(@young_card.sanitized_name)
  end

  it 'should return multiple cards that have been created recently' do
    DownloadedCard.stub(:all).and_return([@young_card, @second_young_card])

    subject.count.should eq(2)
  end

  context 'should not return a card(s)' do
    it 'that is older than our filter' do
      DownloadedCard.stub(:all).and_return([@old_card])

      subject.should be_empty
    end

    it 'that are older than our filter' do
      DownloadedCard.stub(:all).and_return([@old_card, @second_old_card])

      subject.should be_empty
    end

    it 'that is older than our filter, but should return a card that is younger' do
      DownloadedCard.stub(:all).and_return([@old_card, @young_card])

      subject.count.should eq(1)
      subject.first.sanitized_name.should eq(@young_card.sanitized_name)
    end

    it 'that are older than our filter, but should return cards that are younger' do
      DownloadedCard.stub(:all).and_return([@old_card, @young_card, @second_old_card, @second_young_card])

      subject.count.should eq(2)
      subject.first.sanitized_name.should eq(@young_card.sanitized_name)
      subject.last.sanitized_name.should eq(@second_young_card.sanitized_name)
    end

    it 'with invalid start dates' do
      nil_start_date_card = OpenStruct.new(start_date: nil)
      DownloadedCard.stub(:all).and_return([@young_card, nil_start_date_card])

      subject.count.should eq(1)
      subject.first.sanitized_name.should eq(@young_card.sanitized_name)
    end
  end

  it 'does not parse show_only through to active filter' do
    expect(ActiveFilterService).not_to receive(:filter_show_active_cards).with([])
    expect(ActiveFilterService).not_to receive(:filter_show_inactive_cards).with([])
    TrelloService.stub(:all).and_return([])
    TimeFilterService.filter_cards('200', 'Location name', 'all_cards')
  end

  it 'parses show_only active through to active filter' do
    expect(ActiveFilterService).to receive(:filter_show_active_cards).with([])
    TrelloService.stub(:all).and_return([])
    TimeFilterService.filter_cards('200', 'Location name', 'active_cards')
  end

  it 'parses show_only inactive through to active filter' do
    expect(ActiveFilterService).to receive(:filter_show_inactive_cards).with([])
    TrelloService.stub(:all).and_return([])
    TimeFilterService.filter_cards('200', 'Location name', 'inactive_cards')
  end
end