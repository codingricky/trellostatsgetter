require 'rspec'
require 'spec_helper'

describe Card do
  before do
    ConfigService.stub(:source_names).and_return(['A Valid Source'])
  end

  context 'determine time difference between two dates' do
    it 'returns the amount of days lapsed' do
      card = Card.new(name: 'This is a test card.')
      card.end_date = (Date.today - 1).to_time
      card.start_date = (Date.today - 2).to_time
      card.duration_in_days.should eq(1)
    end

    it 'returns nil if start_date is non existent' do
      card = Card.new(name: 'This is a test card.')
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

  context 'a card has no source in its name and there are no attachments' do
    it 'sets source to nil' do
      Card.new(name: 'This is a test card.').source.should eq(nil)
    end
  end

  context 'a card has a source in its name' do
    it 'sets source to the name' do
      Card.new(name: 'This is a test card from a valid source.').source.should eq('A Valid Source')
    end
  end

  context 'a card has a source in its name with different casing' do
    it 'sets source to the name' do
      Card.new(name: 'This is a test card from a ValiD soUrce.').source.should eq('A Valid Source')
    end
  end

  context 'a card does not have a source in its attachment name' do
    it 'sets source to nil' do
      Card.new(name: 'This is a test card', attachments: [ 'Blehblah.docx' ]).source.should eq(nil)
    end
  end

  context 'a card has a source in its attachment name' do
    it 'sets source to the name' do
      Card.new(name: 'This is a test card', attachments: [ 'A Valid Source.pdf' ]).source.should eq('A Valid Source')
    end
  end

  context 'a card has a source in its attachment names' do
    it 'sets source to the name' do
      Card.new(name: 'This is a test card', attachments: [ 'Blehblah.docx', 'A ValId SourCe.pdf' ]).source.should eq('A Valid Source')
    end
  end

  context 'the card has source names in both the card name and attachment name' do
    it 'sets source to the one found in card name' do
      Card.new(name: 'This is a test referral card', attachments: [ 'A Valid Source.pdf' ]).source.should eq('A Valid Source')
    end
  end

end