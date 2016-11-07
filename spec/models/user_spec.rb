require 'rspec'
require 'spec_helper'
require 'omniauth'

describe User do
  before do
    @user = OpenStruct.new
    @user.info = OpenStruct.new
    @user.info.email = 'example@dius.com.au'
    @user.provider = 'google_oauth2'
    @user.uid = '115940111132256041753'

    @user2 = OpenStruct.new
    @user2.info = OpenStruct.new
    @user2.info.email = 'example2@dius.com.au'
    @user2.provider = 'google_oauth2'
    @user2.uid = '115940111132256041754'
  end

  it 'saves the user to the db on their first visit' do
    saved_user = User.from_omniauth(@user)
    saved_user.provider.should eq(@user.provider)
    saved_user.email.should eq(@user.info.email)
    saved_user.uid.should eq(@user.uid)
    saved_user.password.present?.should eq(true)
  end

  it 'only creates and saves new users, but calls up old records for existing users' do
    unique_first_user = User.from_omniauth(@user)
    User.count.should eq(1)
    duplicate_first_user = User.from_omniauth(@user)
    duplicate_first_user.email.should eq(unique_first_user.email)
    duplicate_first_user.id.should eq(unique_first_user.id)
    User.count.should eq(1)
    unique_second_user = User.from_omniauth(@user2)
    unique_second_user.email.should eq(@user2.info.email)
    unique_second_user.uid.should eq(@user2.uid)
    unique_second_user.id.should_not eq(unique_first_user.id)
    User.count.should eq(2)
  end
end