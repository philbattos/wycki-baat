require 'rails_helper'

RSpec.describe "baats/new", type: :view do
  before(:each) do
    assign(:baat, Baat.new(
      :name => "MyString",
      :destination => "MyString",
      :type => ""
    ))
  end

  it "renders new baat form" do
    render

    assert_select "form[action=?][method=?]", baats_path, "post" do

      assert_select "input#baat_name[name=?]", "baat[name]"

      assert_select "input#baat_destination[name=?]", "baat[destination]"

      assert_select "input#baat_type[name=?]", "baat[type]"
    end
  end
end
