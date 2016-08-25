require 'rspec'
require 'spec_helper'

RSpec.describe CardsController, type: :controller do

  describe "GET #index" do
    it "succeeds and renders the :index view" do
      expect_any_instance_of(CardsController).to receive(:index).and_return([])
      get :index
      response.should render_template(:index)
      response.should have_http_status(:success)
    end
  end

  describe "Routing" do
      it "routes / to cards#index" do
        expect_any_instance_of(CardsController).to receive(:index).and_return([])
        visit '/'
        response.should have_http_status(:success)
        response.should render_template(:index)
      end
  end
end