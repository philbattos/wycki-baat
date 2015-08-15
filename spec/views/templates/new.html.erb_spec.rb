require 'rails_helper'

RSpec.describe "templates/new", type: :view do
  before(:each) do
    assign(:template, Template.new(
      :name => "MyString",
      :destination => "MyString"
    ))
  end

  it "renders new template form" do
    render

    assert_select "form[action=?][method=?]", templates_path, "post" do

      assert_select "input#template_name[name=?]", "template[name]"

      assert_select "input#template_destination[name=?]", "template[destination]"
    end
  end
end
