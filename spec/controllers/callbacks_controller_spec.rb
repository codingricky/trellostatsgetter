require 'rspec'
require 'spec_helper'
require 'omniauth'

describe CallbacksController, type: :controller do
  it 'saves and redirects a dius employee to the trello page' do
    request.env['devise.mapping'] = Devise.mappings[:user]
    user = OpenStruct.new
    user.info = OpenStruct.new
    user.info.email = 'example@dius.com.au'
    user.provider = 'google_oauth2'
    user.uid = '115940111132256041753'
    request.env['omniauth.auth'] = user
    get :google_oauth2
    response.should redirect_to '/'
  end
end