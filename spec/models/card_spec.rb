require 'rspec'
require 'spec_helper'

describe Card do
  context 'determine time difference between two dates' do
    it 'returns the amount of days lapsed' do
      card = Card.new
      card.end_date = (Date.today - 1).to_time
      card.start_date = (Date.today - 2).to_time
      card.duration_in_days.should eq(1)
    end

    it 'returns nil if start_date is non existent' do
      card = Card.new
      card.duration_in_days.should eq(nil)
    end
  end

  context 'strip sensitive info' do
    it 'removes money values from the card name' do
      (Card.new(name: '70000')).name.should eq('')
      (Card.new(name: '70 000')).name.should eq('70 ')
      (Card.new(name: '700000')).name.should eq('')
      (Card.new(name: '700 000')).name.should eq(' ')
      (Card.new(name: '70,000')).name.should eq('')
      (Card.new(name: '70, 000')).name.should eq(' ')
      (Card.new(name: '$70 000')).name.should eq(' ')
      (Card.new(name: '$700000')).name.should eq('')
      (Card.new(name: '$700 000')).name.should eq(' ')
      (Card.new(name: '$70,000')).name.should eq('')
      (Card.new(name: '$70, 000')).name.should eq(' ')
      (Card.new(name: '70, 000 - 80, 000')).name.should eq('  -  ')
      (Card.new(name: '70.000')).name.should eq('70.')
      (Card.new(name: '20k')).name.should eq('')
      (Card.new(name: '135k')).name.should eq('')
      (Card.new(name: '$20k')).name.should eq('')
      (Card.new(name: '$135k')).name.should eq('')
      (Card.new(name: '135k - 140k')).name.should eq(' - ')
      (Card.new(name: '$135k - $140k')).name.should eq(' - ')
      (Card.new(name: '145 per day')).name.should eq(' per day')
      (Card.new(name: '1200 per week')).name.should eq(' per week')
      (Card.new(name: '13/05/2016')).name.should eq('13/05/')
      (Card.new(name: 'Billy Bob and Meggy Meg grabbed the $50 000 and ran')).name.should eq('Billy Bob and Meggy Meg grabbed the   and ran')
    end
  end
end