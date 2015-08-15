require 'rails_helper'

RSpec.describe "images/index", type: :view do
  before(:each) do
    assign(:images, [
      Image.create!(
        :name => "Name",
        :destination => "Destination"
      ),
      Image.create!(
        :name => "Name",
        :destination => "Destination"
      )
    ])
  end

  it "renders a list of images" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Destination".to_s, :count => 2
  end
end
