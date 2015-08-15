require 'rails_helper'

RSpec.describe "volumes/show", type: :view do
  before(:each) do
    @volume = assign(:volume, Volume.create!(
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
