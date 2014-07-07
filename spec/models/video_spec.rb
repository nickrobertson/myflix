require 'spec_helper'

describe Video do
  # Test rails framework
    # it "saves itself" do
  #   #setup
  #   video = Video.new(title: "Remember The Titans", description: "Best Disney Movie", small_cover_url: "tmp/monk.jpg", large_cover_url: "tmp/monk_large.jpg")
  #   #action
  #   video.save
  #   #verification aka assertion
  #   expect(Video.first).to eq(video)
  #   #expect(Video.first.title).to eq("Remember The Titans")
  # end

  it { should belong_to(:category)}
  #
  # it "belongs to category" do
  #   dramas = Category.create(name: "Dramas")
  #   monk = Video.create(title: "monk", description: "a great tv show", category: dramas)
  #   expect(monk.category).to eq(dramas)
  # end

  it { should validate_presence_of(:title)}
  #
  # it "does not save a video without a title" do
  #   video = Video.create(description: "Best Disney Movie")
  #   expect(Video.count).to eq(0)
  # end

  it { should validate_presence_of(:description)}
  #
  # it "does not save a video without a description" do
  #   video = Video.create(title: "Nenmo")
  #   expect(Video.count).to eq(0)
  # end

  describe "search_by_title" do
    it "returns an empty array if there is no match" do
      futurama = Video.create(title: "Futurama", description: "Space Travel")
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel")
      expect(Video.search_by_title("hello")).to eq([])
    end

    it "returns an array of one video for an exact match" do
      Video.delete_all
      futurama = Video.create(title: "Futurama", description: "Space Travel")
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel")
      expect(Video.search_by_title("Futurama")).to eq([futurama])
    end

    it "returns an array of one video for a partial match" do
      Video.delete_all
      futurama = Video.create(title: "Futurama", description: "Space Travel")
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel")
      expect(Video.search_by_title("rama")).to eq([futurama])
    end
    it "returns an array of all matches ordered by created_at" do
      Video.delete_all
      futurama = Video.create(title: "Futurama", description: "Space Travel", created_at: 1.day.ago)
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel")
      expect(Video.search_by_title("Futur")).to eq([back_to_future, futurama])
    end

    it "returns and empty array for a search with an empty string" do
      Video.delete_all
      futurama = Video.create(title: "Futurama", description: "Space Travel", created_at: 1.day.ago)
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel")
      expect(Video.search_by_title("")).to eq([])
    end
  end
end