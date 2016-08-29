require 'rspec'
require 'spec_helper'

describe 'cards/index', type: :view do
  it "should display the correct page" do
    render
    rendered.should match /current Trello cards/
  end

  it "should display to the user 'No cards.' when @cards is nil" do
    render
    rendered.should match /No cards/
  end

  it "displays card stats upon loading" do
    @board1 = OpenStruct.new
    @list1 = OpenStruct.new
    @list1.id = '1'
    @list1.name = 'Sample List'
    @board1.lists = [ @list1 ]
    @action1 = OpenStruct.new
    @action1.type = 'createCard'
    @action1.data = {"list"=>{"name"=>"Resumes to be Screened"},
                     "card"=>
                         {"id"=>"1"}}
    @action1.date = '1/1/1991'
    @board1.actions = [ @action1 ]
    @cards = [ Card.new(@board1, 'Michael', '1', '1') ]
    assign(:cards, @cards)
    render
    rendered.should match /Michael/
    rendered.should match /1/
    rendered.should match /Sample List/
    rendered.should match /1991/
  end
end