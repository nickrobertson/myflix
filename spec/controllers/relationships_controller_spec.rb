require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    it "sets @relationships to the current user's following relationships" do
      billy = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(billy)
      relationship = Fabricate(:relationship, follower: billy, leader: bob)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end

  describe "DELETE destroy" do
    # it_behaves_like "require sign in" do
    #   let(:action) { delete :destroy, id: 4 }
    # end

    it "deletes the relationship if the current user is the follower" do
      billy = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(billy)
      relationship = Fabricate(:relationship, follower: billy, leader: bob)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(0)
    end
    it "redirects to the poeple page" do
      billy = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(billy)
      relationship = Fabricate(:relationship, follower: billy, leader: bob)
      delete :destroy, id: relationship
      expect(response).to redirect_to people_path
    end
    it "does not delete the relationship if the current user is not the follower" do
      billy = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(billy)
      charlie = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: charlie, leader: bob)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(1)
    end
  end

  describe "POST create" do
    # it_behaves_like "require sign in" do
    #   let(:action) { post :create, leader_id: 3 }
    # end
    it " redirects to the people page" do
      billy = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(billy)
      post :create, leader_id: bob.id
      expect(response).to redirect_to people_path
    end

    it "creates a relationship that the current user follows the leader" do
      billy = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(billy)
      post :create, leader_id: bob.id
      expect(billy.following_relationships.first.leader).to eq(bob)
    end

    it "does not ceate a relationship if the current user already follows the leader" do
      billy = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(billy)
      Fabricate(:relationship, leader: bob, follower: billy)
      post :create, leader_id: bob.id
      expect(billy.following_relationships.first.leader).to eq(bob)
    end
    it "does not allow one to follow themselves" do
      billy = Fabricate(:user)
      set_current_user(billy)
      post :create, leader_id: billy.id
      expect(Relationship.count).to eq(0)
    end
  end
end