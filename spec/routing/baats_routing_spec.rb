require "rails_helper"

RSpec.describe BaatsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/baats").to route_to("baats#index")
    end

    it "routes to #new" do
      expect(:get => "/baats/new").to route_to("baats#new")
    end

    it "routes to #show" do
      expect(:get => "/baats/1").to route_to("baats#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/baats/1/edit").to route_to("baats#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/baats").to route_to("baats#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/baats/1").to route_to("baats#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/baats/1").to route_to("baats#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/baats/1").to route_to("baats#destroy", :id => "1")
    end

  end
end
