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
      expect(TimeFilterService).to receive(:filter_cards).with(200, 'Sydney - Software Engineers', 'all_cards')
      get :index, :days_old => '200'
    end
  end

  context 'the user has not entered a value into the filter' do
    it 'converts nil to an integer with value 90 and parses it to TimeFilterService' do
      expect(TimeFilterService).to receive(:filter_cards).with(90, 'Sydney - Software Engineers', 'all_cards')
      get :index
    end
  end

  context 'the user inputs a non integer value into the filter' do
    it 'parses 0 to TimeFilterService' do
      expect(TimeFilterService).to receive(:filter_cards).with(0, 'Sydney - Software Engineers', 'all_cards')
      get :index, :days_old => 'pikachu'
    end
  end

  context 'the user has selected Melbourne' do
    it 'parses the value to TimeFilterService' do
      expect(TimeFilterService).to receive(:filter_cards).with(90, 'Melbourne Recruitment Pipeline', 'all_cards')
      get :index, :location => 'Melbourne Recruitment Pipeline'
    end
  end

  context 'the user has selected Sydney' do
    it 'parses the value to TimeFilterService' do
      expect(TimeFilterService).to receive(:filter_cards).with(90, 'Sydney - Software Engineers', 'all_cards')
      get :index, :location => 'Sydney - Software Engineers'
    end
  end

  context 'the user has not selected a location' do
    it 'parses Sydney as a default value to TimeFilterService' do
      expect(TimeFilterService).to receive(:filter_cards).with(90, 'Sydney - Software Engineers', 'all_cards')
      get :index
    end
  end

  context 'the user has selected to show only inactive cards' do
    it 'parses the value to TimeFilterService' do
      expect(TimeFilterService).to receive(:filter_cards).with(90, 'Sydney - Software Engineers', 'inactive_cards')
      get :index, :show_only => 'inactive_cards'
    end
  end

  context 'the user has selected to show only active cards' do
    it 'parses the value to TimeFilterService' do
      expect(TimeFilterService).to receive(:filter_cards).with(90, 'Sydney - Software Engineers', 'active_cards')
      get :index, :show_only => 'active_cards'
    end
  end

  context 'the user has not selected anything' do
    it 'parses all_cards as a default value to TimeFilterService' do
      expect(TimeFilterService).to receive(:filter_cards).with(90, 'Sydney - Software Engineers', 'all_cards')
      get :index
    end
  end
end



