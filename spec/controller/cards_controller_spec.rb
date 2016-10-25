require 'rspec'
require 'spec_helper'

describe CardsController, type: :controller do
  before do
    board = Board.new
    @member = Member.new
    board.cards = [ ]
    board.lists = [ ]
    board.actions = [ ]
    @member.boards = [ board ]
    @current_user = User.create!(:email => 'user@dius.com.au', :password => 'password')
    login_as(@current_user, :scope => :user)
  end

  describe "Routing" do
    it "routes / to cards#index" do
      Trello::Member.stub(:find).and_return(@member)
      ActionService.stub(:get_actions).and_return([[]])
      visit '/'
      response.should have_http_status(:success)
      response.should render_template(:index)
    end

    describe "AWS health checks" do
      it "returns 200" do
        visit '/healthcheck'
        response.should have_http_status(200)
      end
    end
  end

  describe "Handling errors" do
    it "gives the error as a string to @cards" do
      CardService.stub(:all).and_raise('Board name is invalid/not found.')
      visit '/'
      response.should have_http_status(200)
    end
  end

  describe "Handling params from view" do
    it "receives days_ago parameter of 30" do
      expect(TimeFilterService).to receive(:filter_cards).with(30)
      visit '/cards?utf8=%E2%9C%93&days_old=30&commit=Filter'
      response.should have_http_status(200)
    end
  end
end

