require 'spec_helper'

feature 'User following' do
  scenario "user follows and unfollows someone" do
    billy = Fabricate(:user)
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    Fabricate(:review, user: billy, video: video)
    sign_in
    click_on_video_on_home_page(video)

    click_link billy.full_name
    click_link "Follow"
    expect(page).to have_content(billy.full_name)

    unfollow(billy)
    expect(page).not_to have_content(billy.full_name)

  end

  def unfollow(user)
    find("a[data-methods='delete']").click
  end
end