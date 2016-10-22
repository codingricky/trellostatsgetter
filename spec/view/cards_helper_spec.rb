include ActionView::Helpers::DateHelper

describe CardsHelper do
  before do
    @card = OpenStruct.new
    @card.start_date = '2016-08-12'
    @card.end_date = '2016-08-13'
    @card.duration_in_days = "1"
  end

  describe "show start date" do
    it "manipulates the form of the date as anticipated" do
      CardsHelper.show_start_date(@card).should eq(@card.start_date.to_datetime.strftime('%d %b %Y'))
    end
    it "tells the user when there is no date" do
      @card.start_date = nil
      CardsHelper.show_start_date(@card).should eq('This card has never been placed in the Resumes to be Screened lane.')
    end
  end

  describe "show end date" do
    it "manipulates the form of the date as anticipated" do
      CardsHelper.show_end_date(@card).should eq(@card.end_date.to_datetime.strftime('%d %b %Y'))
    end
    it "tells the user when there is no date" do
      @card.end_date = nil
      CardsHelper.show_end_date(@card).should eq('This card is not placed in an end lane.')
    end
  end
end
