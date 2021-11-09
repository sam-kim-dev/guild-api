# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.find_or_initialize_by(id: 1) { |user|
  user.name = "Homer Simpson"
}.save!

User.find_or_initialize_by(id: 2) { |user|
  user.name = "Marge Simpson"
}.save!

User.find_or_initialize_by(id: 3) { |user|
  user.name = "Bart Simpson"
}.save!

User.find_or_initialize_by(id: 4) { |user|
  user.name = "Lisa Simpson"
}.save!

User.find_or_initialize_by(id: 5) { |user|
  user.name = "Maggie Simpson"
}.save!
