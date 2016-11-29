require 'rspec'
require 'spec_helper'

describe DownloadedCard do
  it 'saves with a name field (string)' do
    DownloadedCard.create(sanitized_name: 'Vinny')
    DownloadedCard.first.sanitized_name.should eq('Vinny')
  end

  context 'determines time difference between two dates and' do
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

  context 'when a card is saved,' do
    it 'removes money values from the card name' do
      (DownloadedCard.create(sanitized_name:'70000').sanitized_name.should eq(''))
      (DownloadedCard.create(sanitized_name:'70 000').sanitized_name.should eq('70 '))
      (DownloadedCard.create(sanitized_name:'700000').sanitized_name.should eq(''))
      (DownloadedCard.create(sanitized_name:'700 000').sanitized_name.should eq(' '))
      (DownloadedCard.create(sanitized_name:'70,000').sanitized_name.should eq(''))
      (DownloadedCard.create(sanitized_name:'70, 000').sanitized_name.should eq(' '))
      (DownloadedCard.create(sanitized_name:'$70 000').sanitized_name.should eq(' '))
      (DownloadedCard.create(sanitized_name:'$700000').sanitized_name.should eq(''))
      (DownloadedCard.create(sanitized_name:'$700 000').sanitized_name.should eq(' '))
      (DownloadedCard.create(sanitized_name:'$70,000').sanitized_name.should eq(''))
      (DownloadedCard.create(sanitized_name:'$70, 000').sanitized_name.should eq(' '))
      (DownloadedCard.create(sanitized_name:'70, 000 - 80, 000').sanitized_name.should eq('  -  '))
      (DownloadedCard.create(sanitized_name:'70.000').sanitized_name.should eq('70.'))
      (DownloadedCard.create(sanitized_name:'20k').sanitized_name.should eq(''))
      (DownloadedCard.create(sanitized_name:'135k').sanitized_name.should eq(''))
      (DownloadedCard.create(sanitized_name:'$20k').sanitized_name.should eq(''))
      (DownloadedCard.create(sanitized_name:'$135k').sanitized_name.should eq(''))
      (DownloadedCard.create(sanitized_name:'135k - 140k').sanitized_name.should eq(' - '))
      (DownloadedCard.create(sanitized_name:'$135k - $140k').sanitized_name.should eq(' - '))
      (DownloadedCard.create(sanitized_name:'145 per day').sanitized_name.should eq(' per day'))
      (DownloadedCard.create(sanitized_name:'1200 per week').sanitized_name.should eq(' per week'))
      (DownloadedCard.create(sanitized_name:'13/05/2016').sanitized_name.should eq('13/05/'))
      (DownloadedCard.create(sanitized_name:'Billy Bob and Meggy Meg grabbed the $50 000 and ran').sanitized_name.should eq('Billy Bob and Meggy Meg grabbed the   and ran'))
    end
  end

  it 'has all card fields' do
    name = 'test'
    card_id = '123abc'
    list_id = 'abc123'
    list_name = 'Resumes To Be Screened '
    start_date = (DateTime.now - 1)
    end_date = (DateTime.now)
    url = 'www.dius.com.au'

    DownloadedCard.create(sanitized_name: name,
                          card_id: card_id,
                          list_id: list_id,
                          list_name: list_name,
                          start_date: start_date,
                          end_date: end_date,
                          url: url)

    DownloadedCard.all.count.should eq(1)
    DownloadedCard.first.sanitized_name.should eq(name)
    DownloadedCard.first.card_id.should eq(card_id)
    DownloadedCard.first.list_id.should eq(list_id)
    DownloadedCard.first.list_name.should eq(list_name)
    DownloadedCard.first.start_date.should eq(start_date)
    DownloadedCard.first.end_date.should eq(end_date)
    DownloadedCard.first.url.should eq(url)
  end

end
