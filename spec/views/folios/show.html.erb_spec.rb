require 'rails_helper'

RSpec.describe "folios/show", type: :view do
  before(:each) do
    @folio = assign(:folio, Folio.create!(
      :name => "Name",
      :destination => "Destination"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Destination/)
  end
end
