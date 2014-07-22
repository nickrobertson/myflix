require 'spec_helper'

describe Category do
  #test rails framework
  # it "saves itself" do
  #   #setup
  #   category = Category.new(name: "Action")
  #   #action
  #   category.save
  #   #assertion
  #   expect(Category.first).to eq(category)
  # end

  it {should have_many(:videos)}
  it {should validate_presence_of(:name)}

  # it "has many videos" do
  #   action = Category.create(name: "Action")
  #   rambo = Video.create(title: "Rambo", description: "Action Packed", category: action)
  #   top_gun = Video.create(title: "Top Gun", description: "Action Classic", category: action)
  #   expect(action.videos).to include(rambo, top_gun)
  # end

  describe "#recent_videos" do
    it "returns the videos in the reverse chronical order by created at" do
      comedies = Category.create(name: "comedies")
      what_about_bob = Video.create(title: "What about bob?", description: "Funny movie with Bill Murray", category: comedies, created_at: 1.day.ago)
      simpsons = Video.create(title: "Simpsons", description: "Funny tv shwo", category: comedies)
      expect(comedies.recent_videos).to eq([simpsons, what_about_bob])
    end

    it "returns all videos if there is less that six videos" do
      comedies = Category.create(name: "comedies")
      what_about_bob = Video.create(title: "What about bob?", description: "Funny movie with Bill Murray", category: comedies, created_at: 1.day.ago)
      simpsons = Video.create(title: "Simpsons", description: "Funny tv shwo", category: comedies)
      expect(comedies.recent_videos.count).to eq(2)
    end
    it "returns six videos if there is more six videos" do
      comedies = Category.create(name: "comedies")
      7.times { Video.create(title: "Simpsons", description: "Funny tv shwo", category: comedies) }
      expect(comedies.recent_videos.count).to eq(6)
    end
    it "returns the most recent six videos" do
      comedies = Category.create(name: "comedies")
      6.times { Video.create(title: "Simpsons", description: "Funny tv shwo", category: comedies) }
      what_about_bob = Video.create(title: "What about bob?", description: "Funny movie with Bill Murray", category: comedies, created_at: 1.day.ago)
      expect(comedies.recent_videos).not_to include(what_about_bob)
    end

    it "returns an empty array if the category does not have any videos" do
      comedies = Category.create(name: "comedies")
      expect(comedies.recent_videos).to eq([])
    end
  end
end