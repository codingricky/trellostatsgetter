require 'rspec'
require 'spec_helper'

RSpec.describe CardsController, type: :controller do

board1 = OpenStruct.new
member = OpenStruct.new
board1.cards = [ ]
board1.lists = [ ]
member.boards = [ board1 ]

  describe "GET #index" do
    it "succeeds and renders the :index view" do
      Trello::Member.should_receive(:find).and_return(member)
      get :index
      response.should render_template(:index)
      response.should have_http_status(:success)
    end
  end

  describe "Routing" do
    it "routes / to cards#index" do
      Trello::Member.should_receive(:find).and_return(member)
      visit '/'
      response.should have_http_status(:success)
      response.should render_template(:index)
    end
  end
end