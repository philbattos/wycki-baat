require 'rails_helper'

RSpec.describe "baats/show", type: :view do
  before(:each) do
    @baat = assign(:baat, Baat.create!(
      :name => "Name",
      :destination => "Destination",
      :type => "Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Destination/)
    expect(rendered).to match(/Type/)
  end
end
