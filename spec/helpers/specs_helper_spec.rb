describe SpecsHelper do

  describe 'create empty board' do
    it 'creates and returns an empty board' do
      empty_test_board = SpecsHelper.create_empty_board
      empty_test_board.name.should eq('Sydney - Software Engineers')
      empty_test_board.cards.count.should eq(0)
    end
  end

  describe 'create a board with a card' do
    it 'creates and returns an empty board' do
      test_board = SpecsHelper.create_board_with_card('test card name', 'test list name', ((Date.today).to_time))
      test_board.cards.count.should eq(1)
    end
  end

end
