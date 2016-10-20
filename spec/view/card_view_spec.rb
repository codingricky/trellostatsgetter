require 'rspec'
require 'spec_helper'

describe 'cards/index', type: :view do

  before do
    card_name = 'Michael'
    another_card_name = 'Ricky'
    card_id = '1'
    card_list_id = '1'
    board = SpecsHelper.populate_a_board(card_id, card_list_id)
    dud_action = Action.new('updateCard_finish', '9999923454234', '1/1/1990')
    action_cache = Array.new
    action_cache << [ dud_action ]
    @cards = [ Card.new(CardService.create_list_id_to_name(board), card_name, card_id, card_list_id, action_cache)]
    @two_cards = [ Card.new(CardService.create_list_id_to_name(board), card_name, card_id, card_list_id, action_cache),
                   Card.new(CardService.create_list_id_to_name(board), another_card_name, card_id, card_list_id, action_cache)]
  end

  it "should display the correct page" do
    render
    rendered.should match /Trello/
    rendered.should match /Listing/
    rendered.should match /cards/
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
    create_type = 'createCard'
    update_type = 'updateCard_finish'
    create = Action.new(create_type, card_id, create_date)
    update = Action.new(update_type, card_id, update_date)
    action_cache = Array.new
    action_cache << [ create, update ]
    cards = [ Card.new(CardService.create_list_id_to_name(board), card_name, card_id, card_list_id, action_cache) ]
    assign(:cards, cards)
    render
    rendered.should match /Michael/
    rendered.should match /Success - Hired/
    rendered.should match /1990/
    rendered.should match /1991/
    rendered.should match /about 1 year/
  end

  it "displays the error messages" do
    @error = 'No cards.'
    assign(:cards, @error)
    render
    rendered.should match /No cards/
    @error = 'Error: Board name is invalid/not found.'
    assign(:cards, @error)
    render
    rendered.should match /Error: Board name/
    @error = 'Error: Member ID is invalid/not found.'
    assign(:cards, @error)
    render
    rendered.should match /Error: Member ID/
    @error = 'Error: Member Token is invalid/not found.'
    assign(:cards, @error)
    render
    rendered.should match /Error: Member Token/
  end
end