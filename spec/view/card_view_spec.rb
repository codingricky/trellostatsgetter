require 'rspec'
require 'spec_helper'

describe 'cards/index', type: :view do
  it "should display the correct page" do
    render
    rendered.should match /Trello/
    rendered.should match /Listing/
    rendered.should match /cards/
  end

  it "should display to the user 'No cards.' when @cards is nil" do
    @cards = [  ]
    assign(:cards, @cards)
    render
    rendered.should match /No cards/
  end

  before do
    card_name = 'Michael'
    another_card_name = 'Ricky'
    card_id = '1'
    card_list_id = '1'
    board = SpecsHelper.populate_a_board(card_id, card_list_id)
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
    card_name = 'Michael'
    card_id = '1'
    card_list_id = '1'
    create_date = '1/1/1990'
    update_date = '1/1/1991'
    board = SpecsHelper.populate_a_board_with_stats(card_id, card_list_id, create_date, update_date)
    cards = [ Card.new(board, card_name, card_id, card_list_id) ]
    assign(:cards, cards)
    render
    rendered.should match /Michael/
    rendered.should match /Success - Hired/
    rendered.should match /1990/
    rendered.should match /1991/
    rendered.should match /about 1 year/
  end
end