require 'spec_helper'

describe VideosController do
  describe "GET show" do
    before do
    end
    it "sets @video for authenticatd users" do
      session[:user_id] = User.create(email: 'qa@qao.com', password: '123456', full_name: 'Billy Bob' )
      video = Video.create(title: "What about Bob?", description: "Funniest movie ever!", small_cover_url: "/tmp/futurama.jpg", large_cover_url: "/tmp/monk_large.jpg", category_id: "2")
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "redirects the user to the sign in page for unathenticated users" do
      video = Video.create(title: "What about Bob?", description: "Funniest movie ever!", small_cover_url: "/tmp/futurama.jpg", large_cover_url: "/tmp/monk_large.jpg", category_id: "2")
      get :show, id: video.id
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST search" do
    it "sets @results for authenticated users" do
      Video.delete_all
      session[:user_id] = User.create(email: 'qa@qao.com', password: '123456', full_name: 'Billy Bob' )
      what_about_bob = Video.create(title: "What about Bob?", description: "Funniest movie ever!", small_cover_url: "/tmp/futurama.jpg", large_cover_url: "/tmp/monk_large.jpg", category_id: "2")
      post :search, search_term: 'Bob'
      expect(assigns(:videos)).to eq([what_about_bob])
    end
    it "redirects to sign in page for the unauthenticated users" do
      Video.delete_all
      what_about_bob = Video.create(title: "What about Bob?", description: "Funniest movie ever!", small_cover_url: "/tmp/futurama.jpg", large_cover_url: "/tmp/monk_large.jpg", category_id: "2")
      post :search, search_term: 'Bob'
      expect(response).to redirect_to sign_in_path
    end
  end
end