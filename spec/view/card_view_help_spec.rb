include ActionView::Helpers::DateHelper

describe CardsHelper do
  before do
    @card = OpenStruct.new
    @card.start_date = '2016-08-12'
    @card.end_date = '2016-08-13'
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

  describe "show difference in time" do
    it "shows difference in time between creation of card and card entering and end lane" do
      CardsHelper.show_difference_in_time(@card).should eq(distance_of_time_in_words @card.end_date, @card.start_date)
    end

    it "shows difference in time between creation of card and the present time" do
      @card.end_date = nil
      CardsHelper.show_difference_in_time(@card).should eq((distance_of_time_in_words Time.now, @card.start_date) + '*')
    end

    it "tells the user when there isn't sufficient data" do
      @card.start_date = nil
      @card.end_date = nil
      CardsHelper.show_difference_in_time(@card).should eq('This card duration cannot be calculated as it was not set up properly.')
    end
  end
end
