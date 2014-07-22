require 'spec_helper'

describe QueueItemsController do
  describe "Get index" do
    it "sets @queue_items to the queue items of the logged in user" do
      billy = Fabricate(:user)
      session[:user_id] = billy.id
      queue_item1 = Fabricate(:queue_item, user: billy)
      queue_item2 = Fabricate(:queue_item, user: billy)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])


    end
    it "redirects to the sign in page for authenticated users" do
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end
end