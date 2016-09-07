require 'rspec'
require 'spec_helper'

describe CardsController, type: :controller do
  before do
    board = Board.new
    @member = Member.new
    board.cards = [ ]
    board.lists = [ ]
    @member.boards = [ @board ]
  end

  describe "GET #index" do
    it "succeeds and renders the :index view" do
      Trello::Member.should_receive(:find).and_return(@member)
      get :index
      response.should render_template(:index)
      response.should have_http_status(:success)
    end
  end

  describe "Routing" do
    it "routes / to cards#index" do
      Trello::Member.should_receive(:find).and_return(@member)
      visit '/'
      response.should have_http_status(:success)
      response.should render_template(:index)
    end
  end
end