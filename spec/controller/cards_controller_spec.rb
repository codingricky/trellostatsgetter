require 'rspec'
require 'spec_helper'

describe CardsController, type: :controller do
  before do
    board = Board.new
    @member = Member.new
    board.cards = [ ]
    board.lists = [ ]
    @member.boards = [ board ]
    @current_user = User.create!(:email => 'user@dius.com.au', :password => 'password')
    login_as(@current_user, :scope => :user)
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

