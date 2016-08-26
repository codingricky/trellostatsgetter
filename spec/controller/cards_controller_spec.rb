require 'rspec'
require 'spec_helper'

RSpec.describe CardsController, type: :controller do

  describe "GET #index" do
    it "succeeds and renders the :index view" do
      # TODO
      get :index
      response.should render_template(:index)
      response.should have_http_status(:success)
    end
  end

  describe "Routing" do
      it "routes / to cards#index" do
        visit '/'
        response.should have_http_status(:success)
        response.should render_template(:index)
      end
  end
end