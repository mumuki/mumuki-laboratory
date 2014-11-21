require "spec_helper"

describe SubmissionsController do
  describe "routing" do

    it "routes to #index" do
      get("/submissions").should route_to("submissions#index")
    end

    it "routes to #new" do
      get("/submissions/new").should route_to("submissions#new")
    end

    it "routes to #show" do
      get("/submissions/1").should route_to("submissions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/submissions/1/edit").should route_to("submissions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/submissions").should route_to("submissions#create")
    end

    it "routes to #update" do
      put("/submissions/1").should route_to("submissions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/submissions/1").should route_to("submissions#destroy", :id => "1")
    end

  end
end
