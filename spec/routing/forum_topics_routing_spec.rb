require "spec_helper"

describe ForumTopicsController do
  describe "routing" do

    it "routes to #index" do
      get("/forum_topics").should route_to("forum_topics#index")
    end

    it "routes to #new" do
      get("/forum_topics/new").should route_to("forum_topics#new")
    end

    it "routes to #show" do
      get("/forum_topics/1").should route_to("forum_topics#show", :id => "1")
    end

    it "routes to #edit" do
      get("/forum_topics/1/edit").should route_to("forum_topics#edit", :id => "1")
    end

    it "routes to #create" do
      post("/forum_topics").should route_to("forum_topics#create")
    end

    it "routes to #update" do
      put("/forum_topics/1").should route_to("forum_topics#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/forum_topics/1").should route_to("forum_topics#destroy", :id => "1")
    end

  end
end
