require 'rails_helper'

RSpec.describe "volumes/index", type: :view do
  before(:each) do
    assign(:volumes, [
      Volume.create!(
        :name => "Name",
        :destination => "Destination"
      ),
      Volume.create!(
        :name => "Name",
        :destination => "Destination"
      )
    ])
  end

  it "renders a list of volumes" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Destination".to_s, :count => 2
  end
end
