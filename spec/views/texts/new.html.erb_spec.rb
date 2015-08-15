require 'rails_helper'

RSpec.describe "texts/new", type: :view do
  before(:each) do
    assign(:text, Text.new(
      :name => "MyString",
      :destination => "MyString"
    ))
  end

  it "renders new text form" do
    render

    assert_select "form[action=?][method=?]", texts_path, "post" do

      assert_select "input#text_name[name=?]", "text[name]"

      assert_select "input#text_destination[name=?]", "text[destination]"
    end
  end
end
