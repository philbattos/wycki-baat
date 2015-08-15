require 'rails_helper'

RSpec.describe "volumes/edit", type: :view do
  before(:each) do
    @volume = assign(:volume, Volume.create!(
      :name => "MyString",
      :destination => "MyString"
    ))
  end

  it "renders the edit volume form" do
    render

    assert_select "form[action=?][method=?]", volume_path(@volume), "post" do

      assert_select "input#volume_name[name=?]", "volume[name]"

      assert_select "input#volume_destination[name=?]", "volume[destination]"
    end
  end
end
