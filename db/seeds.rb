# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Restaurant.destroy_all

Restaurant.create(name: "Pizza Place", city: "London", food_type: "Italian", rating: 4, chef: "Steve")
Restaurant.create(name: "Burger Shack", city: "New York", food_type: "Fast food", rating: 2, chef: "Ted")
Restaurant.create(name: "The Wok", city: "Paris", food_type: "Chinese", rating: 5, chef: "Sarah")
Restaurant.create(name: "Happy Cow", city: "Tokyo", food_type: "Ice Cream", rating: 3, chef: "Marie")
Restaurant.create(name: "Wake Up", city: "San Francisco", food_type: "Coffee", rating: 4, chef: "Jeff")
