require "rails_helper"

RSpec.describe VolumesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/volumes").to route_to("volumes#index")
    end

    it "routes to #new" do
      expect(:get => "/volumes/new").to route_to("volumes#new")
    end

    it "routes to #show" do
      expect(:get => "/volumes/1").to route_to("volumes#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/volumes/1/edit").to route_to("volumes#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/volumes").to route_to("volumes#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/volumes/1").to route_to("volumes#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/volumes/1").to route_to("volumes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/volumes/1").to route_to("volumes#destroy", :id => "1")
    end

  end
end
