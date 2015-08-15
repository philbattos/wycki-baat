require 'rails_helper'

RSpec.describe "texts/edit", type: :view do
  before(:each) do
    @text = assign(:text, Text.create!(
      :name => "MyString",
      :destination => "MyString"
    ))
  end

  it "renders the edit text form" do
    render

    assert_select "form[action=?][method=?]", text_path(@text), "post" do

      assert_select "input#text_name[name=?]", "text[name]"

      assert_select "input#text_destination[name=?]", "text[destination]"
    end
  end
end
