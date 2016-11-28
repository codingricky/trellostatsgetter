require 'rspec'
require 'spec_helper'

describe DownloadedCard do
  context 'is an active record' do
    it 'saves to the db' do
      DownloadedCard.create
      DownloadedCard.all.count.should eq(1)
    end

    it 'saves with a name field (string)' do
      DownloadedCard.create(sanitized_name: 'Vinny')
      DownloadedCard.first.sanitized_name.should eq('Vinny')
    end
  end

  context 'determine time difference between two dates' do
    it 'returns the amount of days lapsed' do
      card = DownloadedCard.new(sanitized_name: 'This is a test card.')
      card.end_date = (Date.today - 1).to_time
      card.start_date = (Date.today - 2).to_time
      card.duration_in_days.should eq(1)
    end

    it 'returns nil if start_date is non existent' do
      card = DownloadedCard.new(sanitized_name: 'This is a test card.')
      card.duration_in_days.should eq(nil)
    end
  end
end