# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
@user1 = User.create!(name: "Andra", email: "andra@turing.edu", password: "andrapassword", password_confirmation: "andrapassword", role: 2)
@user2 = User.create!(name: "Hady", email: "hady@turing.edu", password: "hadypassword", password_confirmation: "hadypassword", role: 1)
@visitor = User.create!(name: "Visitor", email: "visitor@turing.edu", password: "visitorpassword", password_confirmation: "visitorpassword")