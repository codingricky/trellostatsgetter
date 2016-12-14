require 'rspec'
require 'spec_helper'
require 'capybara'

describe 'cards/index', type: :view do

  before do
    card_name = 'Michael'
    another_card_name = 'Ricky from a valid source'
    card_id = '1'
    card_list_id = '1'
    create_date = '1/1/1990'
    update_date = '1/1/1991'

    ConfigService.stub(:source_names).and_return( ['A Valid Source'] )
    @cards = [DownloadedCard.create!(sanitized_name: card_name, card_id: card_id, list_id: card_list_id, list_name: 'Sample List', url: 'www.test.com')]
    @two_cards = [@cards.first,
                  DownloadedCard.create!(sanitized_name: another_card_name, card_id: '2', list_id: card_list_id, list_name: 'Success - Hired', start_date: create_date, end_date: update_date)]
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
    rendered.should match /A Valid Source/
  end

  it 'displays card stats (with dates and duration) upon loading' do
    assign(:cards, @two_cards)
    render
    rendered.should match /Michael/
    rendered.should match /Success - Hired/
    rendered.should match /1990/
    rendered.should match /1991/
    rendered.should match /365/
  end

  it 'displays correct colour' do
    @two_cards.second.start_date = (Date.today - 1).to_time
    @two_cards.second.end_date = nil
    assign(:cards, @two_cards)
    render
    rendered.should match /background-color:#008000/
    @two_cards.second.start_date = (Date.today - 11).to_time
    @two_cards.second.end_date = nil
    assign(:cards, @two_cards)
    render
    rendered.should match /background-color:#FFC200/
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

  it 'renders the input fields' do
    render
    rendered.should have_content('Max. days old')
    rendered.should have_button('Submit')
    rendered.should have_field('days_old')
    rendered.should have_field('location_Sydney_-_Software_Engineers')
    rendered.should have_field('location_Melbourne_Recruitment_Pipeline')
    rendered.should have_field('show_only_active_cards')
    rendered.should have_field('show_only_inactive_cards')
    rendered.should have_field('show_only_all_cards')
  end

  it 'retains user values' do
    @location = 'Melbourne Recruitment Pipeline'
    @days_old = 30
    @show_only = 'inactive_cards'
    assign(:location, @location)
    assign(:days_old, @days_old)
    assign(:show_only, @show_only)
    render
    rendered.should have_field('show_only_all_cards', :checked => false)
    rendered.should have_field('show_only_active_cards', :checked => false)
    rendered.should have_field('show_only_inactive_cards', :checked => true)
    rendered.should have_field('location_Sydney_-_Software_Engineers', :checked => false)
    rendered.should have_field('location_Melbourne_Recruitment_Pipeline', :checked => true)
    rendered.should have_field('days_old', :with => 30)
  end

  it 'links the card name to the card url' do
    assign(:cards, @cards)
    render
    rendered.should have_link(@cards.first.sanitized_name, href: @cards.first.url)
  end
end
