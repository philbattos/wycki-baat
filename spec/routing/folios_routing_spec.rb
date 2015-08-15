require "rails_helper"

RSpec.describe FoliosController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/folios").to route_to("folios#index")
    end

    it "routes to #new" do
      expect(:get => "/folios/new").to route_to("folios#new")
    end

    it "routes to #show" do
      expect(:get => "/folios/1").to route_to("folios#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/folios/1/edit").to route_to("folios#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/folios").to route_to("folios#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/folios/1").to route_to("folios#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/folios/1").to route_to("folios#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/folios/1").to route_to("folios#destroy", :id => "1")
    end

  end
end
