require 'rspec'
require 'spec_helper'
require 'trello'

describe CardsController, type: :controller do
  before do
    TimeFilterService.stub(:filter_cards).and_return([])
    @first_card = OpenStruct.new
    @second_card = OpenStruct.new
  end

  it 'successfully returns' do
    get :index
    response.should have_http_status(:success)
  end

  it 'renders the index' do
    get :index
    response.should render_template(:index)
  end

  it 'assigns a card' do
    @first_card = OpenStruct.new
    TimeFilterService.stub(:filter_cards).and_return([@first_card])
    get :index
    assigns(:cards).should eq([@first_card])
  end

  it 'assigns multiples cards' do
    TimeFilterService.stub(:filter_cards).and_return([@first_card, @second_card])
    get :index
    assigns(:cards).should eq([@first_card, @second_card])
  end

  context 'zero card' do
    it 'assigns zero cards' do
      get :index
      assigns(:cards).should be_empty
    end

    it 'assigns error message' do
      get :index
      assigns(:error).should eq('No cards.')
    end
  end

  context 'raises error' do
    it 'assigns error message when an invalid token is encountered' do
      TimeFilterService.stub(:filter_cards).and_raise('invalid token')
      get :index
      assigns(:error).should eq('invalid token')
    end
  end

  context 'the user has input a value into the filter' do
    it 'parses the value as an integer to TimeFilterService' do
      expect(TimeFilterService).to receive(:filter_cards).with(200)
      get :index, :days_old => "200"
    end
  end

  context 'the user has not entered a value into the filter' do
    it 'converts nil to an integer and parses it to TimeFilterService' do
      expect(TimeFilterService).to receive(:filter_cards).with(0)
      get :index
    end
  end

  context 'the user inputs a non integer value into the filter' do
    it 'parses 0 to TimeFilterService' do
      expect(TimeFilterService).to receive(:filter_cards).with(0)
      get :index, :days_old => "pik@chu"
    end
  end
end



