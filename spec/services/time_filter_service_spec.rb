require 'rspec'
require 'spec_helper'
require 'trello'

describe TimeFilterService do

  let(:days_ago) { 200 }
  subject { TimeFilterService.filter_cards(days_ago) }

  before do
    @old_card = OpenStruct.new(start_date: (Date.today - days_ago - 1).to_time)
    @second_old_card = OpenStruct.new(start_date: (Date.today - days_ago - 1).to_time)

    @young_card = OpenStruct.new(start_date: (Date.today - days_ago + 1).to_time)
    @second_young_card = OpenStruct.new(start_date: (Date.today - days_ago + 1).to_time)
  end

  it 'should return one card that has been created recently' do
    CardService.stub(:all).and_return([@young_card])

    subject.count.should eq(1)
    subject.first.should eq(@young_card)
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
      subject.first.should eq(@young_card)
    end

    it 'that are older than our filter, but should return cards that are younger' do
      CardService.stub(:all).and_return([@old_card, @young_card, @second_old_card, @second_young_card])

      subject.count.should eq(2)
      subject.first.should eq(@young_card)
      subject.last.should eq(@second_young_card)
    end

    it 'with invalid start dates' do
      nil_start_date_card = OpenStruct.new(start_date: nil)
      CardService.stub(:all).and_return([@young_card, nil_start_date_card])

      subject.count.should eq(1)
      subject.first.should eq(@young_card)
    end
  end

end