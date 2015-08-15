require 'rails_helper'

RSpec.describe "volumes/new", type: :view do
  before(:each) do
    assign(:volume, Volume.new(
      :name => "MyString",
      :destination => "MyString"
    ))
  end

  it "renders new volume form" do
    render

    assert_select "form[action=?][method=?]", volumes_path, "post" do

      assert_select "input#volume_name[name=?]", "volume[name]"

      assert_select "input#volume_destination[name=?]", "volume[destination]"
    end
  end
end
