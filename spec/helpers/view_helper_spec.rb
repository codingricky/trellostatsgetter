describe ViewHelper do
    it 'returns 0 when no cards are present' do
      @cards = []
      ViewHelper.calculate_average_duration(@cards).should eq(0)
    end

    it 'returns 0 when dividing by zero' do
      card = OpenStruct.new(duration_in_days: 0)
      @cards = [ card, card ]
      ViewHelper.calculate_average_duration(@cards).should eq(0)
    end

    it 'returns average' do
      card = OpenStruct.new(duration_in_days: 2)
      card2 = OpenStruct.new(duration_in_days: 4)
      @cards = [ card, card2 ]
      ViewHelper.calculate_average_duration(@cards).should eq(3)
    end
end