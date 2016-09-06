require 'rspec'
require 'spec_helper'

describe List do
  before do
    @list_name = 'Sample List Name'
    @list_id = '1'
  end

  it "takes two arguments and creates the list" do
    @list = List.new(@list_id, @list_name)
    @list.id.should eq(@list_id)
    @list.name.should eq(@list_name)
  end
end