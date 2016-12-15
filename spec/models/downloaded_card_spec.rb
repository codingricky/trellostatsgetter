require 'rspec'
require 'spec_helper'

describe DownloadedCard do
  before do
    ConfigService.stub(:source_names).and_return(['A Valid Source'])
  end

  let(:sydney) { 'Sydney' }

  it 'saves with a name field (string)' do
    create(:downloaded_card, sanitized_name: 'Vinny')
    DownloadedCard.first.sanitized_name.should eq('Vinny')
  end

  context 'is_active?' do
    it 'no end date means it is active' do
      create(:downloaded_card)
      DownloadedCard.first.is_active?.should be true
    end

    it 'end date presents means it is active' do
      create(:downloaded_card, end_date: DateTime.now)
      DownloadedCard.first.is_active?.should be false
    end
  end

  context 'search' do
    before do
      active_sydney_1 = create(:downloaded_card, location: sydney, start_date: DateTime.now - 5.days)
      active_sydney_2 = create(:downloaded_card, location: sydney, start_date: DateTime.now - 5.days)
      inactive_sydney_2 = create(:downloaded_card, location: sydney, start_date: DateTime.now - 5.days, end_date: DateTime.now)
      really_old_sydney = create(:downloaded_card, location: sydney,
                                 start_date: DateTime.now - 200.days,
                                 end_date: DateTime.now - 100.days)
      active_melbourne = create(:downloaded_card, location: 'Melbourne', start_date: DateTime.now - 5.days)
      invalid_sydney = create(:downloaded_card, location: sydney, start_date: nil)

    end

    it 'should return matching locations only' do
      DownloadedCard.search(sydney, 90).count.should eq(3)
    end

    it 'should only return active' do
      DownloadedCard.search(sydney, 90, true).count.should eq(2)
    end

    it 'should only return inactive' do
      DownloadedCard.search(sydney, 90, false).count.should eq(1)
    end

    it 'should only ignore really old card' do
      DownloadedCard.search(sydney, 90).count.should eq(3)
    end

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
      (DownloadedCard.create(sanitized_name: '70000').sanitized_name.should eq(''))
      (DownloadedCard.create(sanitized_name: '70 000').sanitized_name.should eq('70 '))
      (DownloadedCard.create(sanitized_name: '700000').sanitized_name.should eq(''))
      (DownloadedCard.create(sanitized_name: '700 000').sanitized_name.should eq(' '))
      (DownloadedCard.create(sanitized_name: '70,000').sanitized_name.should eq(''))
      (DownloadedCard.create(sanitized_name: '70, 000').sanitized_name.should eq(' '))
      (DownloadedCard.create(sanitized_name: '$70 000').sanitized_name.should eq(' '))
      (DownloadedCard.create(sanitized_name: '$700000').sanitized_name.should eq(''))
      (DownloadedCard.create(sanitized_name: '$700 000').sanitized_name.should eq(' '))
      (DownloadedCard.create(sanitized_name: '$70,000').sanitized_name.should eq(''))
      (DownloadedCard.create(sanitized_name: '$70, 000').sanitized_name.should eq(' '))
      (DownloadedCard.create(sanitized_name: '70, 000 - 80, 000').sanitized_name.should eq('  -  '))
      (DownloadedCard.create(sanitized_name: '70.000').sanitized_name.should eq('70.'))
      (DownloadedCard.create(sanitized_name: '20k').sanitized_name.should eq(''))
      (DownloadedCard.create(sanitized_name: '135k').sanitized_name.should eq(''))
      (DownloadedCard.create(sanitized_name: '$20k').sanitized_name.should eq(''))
      (DownloadedCard.create(sanitized_name: '$135k').sanitized_name.should eq(''))
      (DownloadedCard.create(sanitized_name: '135k - 140k').sanitized_name.should eq(' - '))
      (DownloadedCard.create(sanitized_name: '$135k - $140k').sanitized_name.should eq(' - '))
      (DownloadedCard.create(sanitized_name: '145 per day').sanitized_name.should eq(' per day'))
      (DownloadedCard.create(sanitized_name: '1200 per week').sanitized_name.should eq(' per week'))
      (DownloadedCard.create(sanitized_name: '13/05/2016').sanitized_name.should eq('13/05/'))
      (DownloadedCard.create(sanitized_name: 'Billy Bob and Meggy Meg grabbed the $50 000 and ran').sanitized_name.should eq('Billy Bob and Meggy Meg grabbed the   and ran'))
    end

    context 'a card has no source in its name and there are no attachments' do
      it 'sets source to nil' do
        DownloadedCard.create(sanitized_name: 'This is a test card.').source.should eq(nil)
      end
    end

    context 'a card has a source in its name' do
      it 'sets source to the name' do
        DownloadedCard.create(sanitized_name: 'This is a test card from a valid source.').source.should eq('A Valid Source')
      end
    end

    context 'a card has a source in its name with different casing' do
      it 'sets source to the name' do
        DownloadedCard.create(sanitized_name: 'This is a test card from a ValiD soUrce.').source.should eq('A Valid Source')
      end
    end

    context 'a card does not have a source in its attachment name' do
      it 'sets source to nil' do
        DownloadedCard.create(sanitized_name: 'This is a test card', attachments: ['Blehblah.docx']).source.should eq(nil)
      end
    end

    context 'a card has a source in its attachment name' do
      it 'sets source to the name' do
        DownloadedCard.create(sanitized_name: 'This is a test card', attachments: ['A Valid Source.pdf']).source.should eq('A Valid Source')
      end
    end

    context 'a card has a source in its attachment names' do
      it 'sets source to the name' do
        DownloadedCard.create(sanitized_name: 'This is a test card', attachments: ['Blehblah.docx', 'A ValId SourCe.pdf']).source.should eq('A Valid Source')
      end
    end

    context 'the card has source names in both the card name and attachment name' do
      it 'sets source to the one found in card name' do
        DownloadedCard.create(sanitized_name: 'This is a test referral card', attachments: ['A Valid Source.pdf']).source.should eq('A Valid Source')
      end
    end
  end

  it 'has all card fields' do
    name = 'test'
    card_id = '123abc'
    list_id = 'abc123'
    list_name = 'Resumes To Be Screened '
    start_date = Time.parse('1/1/1991')
    end_date = Time.parse('2/1/1991')
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