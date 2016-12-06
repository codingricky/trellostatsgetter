require 'rspec'
require 'spec_helper'
require 'trello'

describe CardsController, type: :controller do
  before do
    DownloadedCard.stub(:search).and_return([])
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
    DownloadedCard.stub(:search).and_return([@first_card])
    get :index
    assigns(:cards).should eq([@first_card])
  end

  it 'assigns multiples cards' do
    DownloadedCard.stub(:search).and_return([@first_card, @second_card])
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

  it 'the user has input a value into the filter' do
    expect(DownloadedCard).to receive(:search).with('Sydney - Software Engineers', 200, true)
    get :index, :days_old => '200'
  end


  it 'the user inputs a non integer value into the filter' do
    expect(DownloadedCard).to receive(:search).with('Sydney - Software Engineers', 0, true)
    get :index, :days_old => 'pikachu'
  end

  it 'the user has selected a location' do
    expect(DownloadedCard).to receive(:search).with('location', 90, true)
    get :index, :location => 'location'
  end

  it 'the user has selected to show only inactive cards' do
    expect(DownloadedCard).to receive(:search).with('Sydney - Software Engineers', 90, false)
    get :index, :show_only => 'inactive_cards'
  end

  it 'the user has selected to show all cards' do
    expect(DownloadedCard).to receive(:search).with('Sydney - Software Engineers', 90, nil)
    get :index, :show_only => 'all_cards'
  end

  it 'the user has selected to show active cards' do
    expect(DownloadedCard).to receive(:search).with('Sydney - Software Engineers', 90, true)
    get :index, :show_only => 'active_cards'
  end

  it 'the user has not selected anything' do
    expect(DownloadedCard).to receive(:search).with('Sydney - Software Engineers', 90, true)
    get :index
  end

  context '/download' do
    it 'calls DownloadedCardService' do
      expect(DownloadedCardService).to receive(:download_cards)
      TrelloService.stub(:all).and_return([])
      response.status.should eq(200)
      get :download
    end
  end
end
