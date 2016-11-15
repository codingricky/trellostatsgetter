include ActionView::Helpers::DateHelper

describe CardsHelper do
  before do
    @card = OpenStruct.new
    @card.start_date = (Date.today).to_time
    @card.end_date = (Date.today - 1).to_time
    @card.duration_in_days = 1
  end

  describe 'show start date' do
    it 'manipulates the form of the date as anticipated' do
      CardsHelper.show_start_date(@card).should eq(@card.start_date.to_datetime.strftime('%d %b %Y'))
    end

    it 'tells the user when there is no date' do
      @card.start_date = nil
      CardsHelper.show_start_date(@card).should eq('This card has never been placed in the Resumes to be Screened lane.')
    end
  end

  describe 'show end date' do
    it 'manipulates the form of the date as anticipated' do
      CardsHelper.show_end_date(@card).should eq(@card.end_date.to_datetime.strftime('%d %b %Y'))
    end

    it 'tells the user when there is no date' do
      @card.end_date = nil
      CardsHelper.show_end_date(@card).should eq('This card is not placed in an end lane.')
    end
  end

  describe 'show colour status' do
    it 'returns the hex code green for cards completed within 10 days' do
      CardsHelper.show_colour_status(@card).should eq('#008000')
    end

    it 'returns the hex code amber for cards completed between 10 and 20 days' do
      @card.duration_in_days = 11
      CardsHelper.show_colour_status(@card).should eq('#FFC200')
    end

    it 'returns the hex code red for cards completed after 20 days' do
      @card.duration_in_days = 21
      CardsHelper.show_colour_status(@card).should eq('#FF0000')
    end

    it 'returns no hex code for cards that are still active' do
      @card.end_date = nil
      CardsHelper.show_colour_status(@card).should eq('')
    end
  end
end
