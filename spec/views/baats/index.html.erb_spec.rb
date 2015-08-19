require 'rails_helper'

RSpec.describe "baats/index", type: :view do
  before(:each) do
    assign(:baats, [
      Baat.create!(
        :name => "Name",
        :destination => "Destination",
        :type => "Type"
      ),
      Baat.create!(
        :name => "Name",
        :destination => "Destination",
        :type => "Type"
      )
    ])
  end

  it "renders a list of baats" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Destination".to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
  end
end
