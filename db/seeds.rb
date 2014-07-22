# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Video.create(title: "Dumb and Dumber", description: "Funniest movie ever!", small_cover_url: "/tmp/monk.jpg", large_cover_url: "/tmp/monk_large.jpg", category_id: "1")
bob = Video.create(title: "What about Bob?", description: "Funniest movie ever!", small_cover_url: "/tmp/futurama.jpg", large_cover_url: "/tmp/monk_large.jpg", category_id: "1")

billy = User.create(full_name: "Billy Bob", password: "password", email: 'billy@test.com')

Category.create(id: 1, name: "comedy", )

Review.create(user: billy, video: bob, rating: 5, content: "This is the best movie ever!")
Review.create(user: billy, video: bob, rating: 3, content: "This is a good movie")