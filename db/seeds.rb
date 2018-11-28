# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Restaurant.destroy_all

require 'faker'
Restaurant.create(name: Faker::Company.name, city: Faker::Address.city, food_type: Faker::Dessert.variety, rating: Faker::Number.between(1, 5), chef: Faker::FamilyGuy.character)
Restaurant.create(name: Faker::Company.name, city: Faker::Address.city, food_type: Faker::Dessert.variety, rating: Faker::Number.between(1, 5), chef: Faker::FamilyGuy.character)
Restaurant.create(name: Faker::Company.name, city: Faker::Address.city, food_type: Faker::Dessert.variety, rating: Faker::Number.between(1, 5), chef: Faker::FamilyGuy.character)
Restaurant.create(name: Faker::Company.name, city: Faker::Address.city, food_type: Faker::Dessert.variety, rating: Faker::Number.between(1, 5), chef: Faker::FamilyGuy.character)
Restaurant.create(name: Faker::Company.name, city: Faker::Address.city, food_type: Faker::Dessert.variety, rating: Faker::Number.between(1, 5), chef: Faker::FamilyGuy.character)
Restaurant.create(name: Faker::Company.name, city: Faker::Address.city, food_type: Faker::Dessert.variety, rating: Faker::Number.between(1, 5), chef: Faker::FamilyGuy.character)
Restaurant.create(name: Faker::Company.name, city: Faker::Address.city, food_type: Faker::Dessert.variety, rating: Faker::Number.between(1, 5), chef: Faker::FamilyGuy.character)
Restaurant.create(name: Faker::Company.name, city: Faker::Address.city, food_type: Faker::Dessert.variety, rating: Faker::Number.between(1, 5), chef: Faker::FamilyGuy.character)
Restaurant.create(name: Faker::Company.name, city: Faker::Address.city, food_type: Faker::Dessert.variety, rating: Faker::Number.between(1, 5), chef: Faker::FamilyGuy.character)
Restaurant.create(name: Faker::Company.name, city: Faker::Address.city, food_type: Faker::Dessert.variety, rating: Faker::Number.between(1, 5), chef: Faker::FamilyGuy.character)
Restaurant.create(name: Faker::Company.name, city: Faker::Address.city, food_type: Faker::Dessert.variety, rating: Faker::Number.between(1, 5), chef: Faker::FamilyGuy.character)
