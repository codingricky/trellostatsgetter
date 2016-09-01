require 'rspec'
require 'spec_helper'

describe 'cards/index', type: :view do
  it "should display the correct page" do
    render
    rendered.should match /current Trello cards/
  end

  it "should display to the user 'No cards.' when @cards is nil" do
    render
    rendered.should match /No cards/
  end

  before do
    @list_id = '1'
    @list_name = 'Sample List'
    @action_type = 'createCard'
    @action_data = '1'
    @action_date = '1/1/1991'
    @card_name = 'Michael'
    @card_id = '1'
    @card_list_id = '1'
  end

  it "displays card stats upon loading" do
    @board = Board.new
    @list = List.new(@list_id, @list_name)
    @lists = [ @list ]
    @board.lists = @lists
    @action = Action.new(@action_type, @action_data, @action_date)
    @board.actions = [ @action ]
    @cards = [ Card.new(@board, @card_name, @card_id, @card_list_id) ]
    assign(:cards, @cards)
    render
    rendered.should match /Michael/
    rendered.should match /1/
    rendered.should match /Sample List/
    rendered.should match /1991/
  end
end