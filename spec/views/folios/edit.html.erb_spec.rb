require 'rails_helper'

RSpec.describe "folios/edit", type: :view do
  before(:each) do
    @folio = assign(:folio, Folio.create!(
      :name => "MyString",
      :destination => "MyString"
    ))
  end

  it "renders the edit folio form" do
    render

    assert_select "form[action=?][method=?]", folio_path(@folio), "post" do

      assert_select "input#folio_name[name=?]", "folio[name]"

      assert_select "input#folio_destination[name=?]", "folio[destination]"
    end
  end
end
