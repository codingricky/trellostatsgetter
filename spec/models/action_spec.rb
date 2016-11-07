require 'rspec'
require 'spec_helper'

describe Action do
    before do
      @action_type_create = 'createCard'
      @action_type_update = 'updateCard'
      @action_type_moved = 'movedCard'
      @card_id = '1'
      @action_date = Time.parse('23/12/1990')
    end

    it 'takes three arguments and creates a createCard action' do
      action = Action.new(@action_type_create, @card_id, @action_date)
      action.type.should eq(@action_type_create)
      action.data.should eq({'list' =>{'name' => 'Resumes to be Screened'},
                             'card' =>
                                 {'id' =>@card_id}})
      action.date.should eq(@action_date)
    end

    it 'takes three arguments and creates an updateCard action' do
      action = Action.new(@action_type_update, @card_id, @action_date)
      action.type.should eq(@action_type_update)
      action.data.should eq({'listAfter' =>{'name' => 'Resumes to be Screened'},
                             'card' =>
                                 {'id' =>@card_id}})
      action.date.should eq(@action_date)
    end

    it 'takes three arguments and creates an updateCard action from a movedCard' do
      action = Action.new(@action_type_moved, @card_id, @action_date)
      action.type.should eq(@action_type_update)
      action.data.should eq({'card' =>{'id' =>@card_id}})
      action.date.should eq(@action_date)
    end
end

