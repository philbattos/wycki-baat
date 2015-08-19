require 'rails_helper'

RSpec.describe "Baats", type: :request do
  describe "GET /baats" do
    it "works! (now write some real specs)" do
      get baats_path
      expect(response).to have_http_status(200)
    end
  end
end
