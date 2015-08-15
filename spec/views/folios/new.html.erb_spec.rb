require 'rails_helper'

RSpec.describe "folios/new", type: :view do
  before(:each) do
    assign(:folio, Folio.new(
      :name => "MyString",
      :destination => "MyString"
    ))
  end

  it "renders new folio form" do
    render

    assert_select "form[action=?][method=?]", folios_path, "post" do

      assert_select "input#folio_name[name=?]", "folio[name]"

      assert_select "input#folio_destination[name=?]", "folio[destination]"
    end
  end
end
