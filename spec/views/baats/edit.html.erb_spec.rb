require 'rails_helper'

RSpec.describe "baats/edit", type: :view do
  before(:each) do
    @baat = assign(:baat, Baat.create!(
      :name => "MyString",
      :destination => "MyString",
      :type => ""
    ))
  end

  it "renders the edit baat form" do
    render

    assert_select "form[action=?][method=?]", baat_path(@baat), "post" do

      assert_select "input#baat_name[name=?]", "baat[name]"

      assert_select "input#baat_destination[name=?]", "baat[destination]"

      assert_select "input#baat_type[name=?]", "baat[type]"
    end
  end
end
