require 'rspec'
require 'spec_helper'
require 'capybara'

describe 'cards/index', type: :view do

  before do
    card_name = 'Michael'
    another_card_name = 'Ricky'
    card_id = '1'
    card_list_id = '1'
    create_date = '1/1/1990'
    update_date = '1/1/1991'

    @cards = [ Card.new(name: card_name, id: card_id, list_id: card_list_id, list_name: 'Sample List')]
    @two_cards = [ @cards.first,
                   Card.new(name: another_card_name, id: '2', list_id: card_list_id, list_name: 'Success - Hired', start_date: create_date, end_date: update_date)]
  end

  it 'should display the correct page' do
    render
    rendered.should match /Trello/
    rendered.should match /Listing/
    rendered.should match /cards/
  end

  it 'displays card stats upon loading' do
    assign(:cards, @cards)
    render
    rendered.should match /Michael/
    rendered.should match /Sample List/
    rendered.should match /This card has never been placed in the Resumes to be Screened lane/
    rendered.should match /This card is not placed in an end lane/
  end

  it 'displays multiple card stats upon loading' do
    assign(:cards, @two_cards)
    render
    rendered.should match /Michael/
    rendered.should match /Sample List/
    rendered.should match /This card has never been placed in the Resumes to be Screened lane/
    rendered.should match /This card is not placed in an end lane/
    rendered.should match /Ricky/
  end

  it 'displays card stats (with dates and duration) upon loading' do
    assign(:cards, @two_cards)
    render
    rendered.should match /Michael/
    rendered.should match /Success - Hired/
    rendered.should match /1990/
    rendered.should match /1991/
    rendered.should match /365/
    rendered.should match /background-color:#FF0000/
  end

  it 'displays correct colour' do
    @two_cards.second.end_date = '2/1/1990'
    assign(:cards, @two_cards)
    render
    rendered.should match /background-color:#008000/

    @two_cards.second.end_date = '12/1/1990'
    assign(:cards, @two_cards)
    render
    rendered.should match /background-color:#FFC200/
    #make a cuke test?
  end

  it 'displays the error messages' do
    @error = 'No cards.'
    assign(:error, @error)
    render
    rendered.should match /No cards/
    @error = 'Error: Board name is invalid/not found.'
    assign(:error, @error)
    render
    rendered.should match /Error: Board name/
    @error = 'Error: Member ID is invalid/not found.'
    assign(:error, @error)
    render
    rendered.should match /Error: Member ID/
    @error = 'Error: Member Token is invalid/not found.'
    assign(:error, @error)
    render
    rendered.should match /Error: Member Token/
  end

  it 'passes user input back to the controller' do
    render
    rendered.should have_content('Max. days old')
    rendered.should have_button('Filter')
    rendered.should have_field('days_old')
  end
end