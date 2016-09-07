require 'rspec'
require 'spec_helper'

describe 'cards/index', type: :view do
  it "should display the correct page" do
    render
    rendered.should match /current Trello cards/
  end

  it "should display to the user 'No cards.' when @cards is nil" do
    @cards = [  ]
    assign(:cards, @cards)
    render
    rendered.should match /No cards/
  end

  before do
    list_id = '1'
    list_name = 'Sample List'
    action_type = 'createCard'
    action_data = '1'
    action_date = nil
    card_name = 'Michael'
    another_card_name = 'Ricky'
    card_id = '1'
    card_list_id = '1'

    board = Board.new
    list = List.new(list_id, list_name)
    lists = [ list ]
    board.lists = lists
    action = Action.new(action_type, action_data, action_date)
    board.actions = [ action ]
    @cards = [ Card.new(board, card_name, card_id, card_list_id)]
    @two_cards = [ Card.new(board, card_name, card_id, card_list_id), Card.new(board, another_card_name, card_id, card_list_id)]
  end

  it "displays card stats upon loading" do
    assign(:cards, @cards)
    render
    rendered.should match /Michael/
    rendered.should match /Sample List/
    rendered.should match /This card has never been placed in the Resumes to be Screened lane/
    rendered.should match /This card is not placed in an end lane/
    rendered.should match /This card duration cannot be calculated/
  end

  it "displays multiple card stats upon loading" do
    assign(:cards, @two_cards)
    render
    rendered.should match /Michael/
    rendered.should match /Sample List/
    rendered.should match /This card has never been placed in the Resumes to be Screened lane/
    rendered.should match /This card is not placed in an end lane/
    rendered.should match /This card duration cannot be calculated/
    rendered.should match /Ricky/
  end

  it "displays card stats (with dates and duration) upon loading" do
    list_id = '1'
    list_name = 'Success List'
    create_type = 'createCard'
    create_data = '1'
    create_date = '1/1/1990'
    update_type = 'updateCard_finish'
    update_data = '1'
    update_date = '1/1/1991'
    card_name = 'Michael'
    card_id = '1'
    card_list_id = '1'
    board = Board.new
    list = List.new(list_id, list_name)
    lists = [ list ]
    board.lists = lists
    create = Action.new(create_type, create_data, create_date)
    update = Action.new(update_type, update_data, update_date)
    board.actions = [ create, update ]
    cards = [ Card.new(board, card_name, card_id, card_list_id) ]

    assign(:cards, cards)
    render
    rendered.should match /Michael/
    rendered.should match /Success List/
    rendered.should match /1990/
    rendered.should match /1991/
    rendered.should match /about 1 year/
  end
end