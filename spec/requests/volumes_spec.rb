require 'rails_helper'

RSpec.describe "Volumes", type: :request do
  describe "GET /volumes" do
    it "works! (now write some real specs)" do
      get volumes_path
      expect(response).to have_http_status(200)
    end
  end
end
