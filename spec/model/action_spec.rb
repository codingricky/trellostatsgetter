require 'rspec'
require 'spec_helper'

describe Action do
    before do
      @action_type_create = 'createCard'
      @action_type_update = 'updateCard'
      @action_id = '1'
      @action_date = '1990'
    end

    it "takes three arguments and creates a createCard action" do
      action = Action.new(@action_type_create, @action_id, @action_date)
      action.type.should eq(@action_type_create)
      action.data.should eq({"list"=>{"name"=>"Resumes to be Screened"},
                             "card"=>
                                 {"id"=>@action_id}})
      action.date.should eq(@action_date)
    end

    it "takes three arguments and creates an updateCard action" do
      action = Action.new(@action_type_update, @action_id, @action_date)
      action.type.should eq(@action_type_update)
      action.data.should eq({"listAfter"=>{"name"=>"Resumes to be Screened"},
                             "card"=>
                                 {"id"=>@action_id}})
      action.date.should eq(@action_date)
    end
end

