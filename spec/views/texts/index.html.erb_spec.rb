require 'rails_helper'

RSpec.describe "texts/index", type: :view do
  before(:each) do
    assign(:texts, [
      Text.create!(
        :name => "Name",
        :destination => "Destination"
      ),
      Text.create!(
        :name => "Name",
        :destination => "Destination"
      )
    ])
  end

  it "renders a list of texts" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Destination".to_s, :count => 2
  end
end
