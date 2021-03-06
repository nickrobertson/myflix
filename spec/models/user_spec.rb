require 'spec_helper'

describe User do
  it { should validate_presence_of(:email)}
  it { should validate_presence_of(:password)}
  it { should validate_presence_of(:full_name)}
  it { should validate_uniqueness_of(:email)}
  it { should have_many(:queue_items), -> {order :position}}
  it { should have_many(:reviews).order("created_at DESC")}

  it "generates a random token when the user is created" do
    alice = Fabricate(:user)
    expect(alice.token).not_to be(blank?)
  end

  describe "#queued_video?" do
    it "returns true when the user queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      expect(user.queued_video?(video)).to eq(true)
    end

    it "returns false when the user hasn't queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      expect(user.queued_video?(video)).to eq(false)
    end
  end

  describe '#follows?' do
    it "returns true if the user has a following relationship with another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:relationship, leader: bob, follower: alice)
      expect(alice.follows?(bob)).to eq(true)
    end
    it 'returns false fi the user does not have a following relationship with another user' do
      billy = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:relationship, leader: billy, follower: bob)
      expect(billy.follows?(bob)).to eq(false)
    end
  end

  describe "#follow" do
    it "follows another user" do
      billy = Fabricate(:user)
      bob = Fabricate(:user)
      billy.follow(bob)
      expect(billy.follows?(bob)).to eq(true)
    end
    it "does not follow one self" do
      billy = Fabricate(:user)
      bob = Fabricate(:user)
      billy.follow(billy)
      expect(billy.follows?(billy)).to eq(false)
    end
  end
end