# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User.new(
  email: 'admin@example.com',
  first_name: 'Sample', 
  last_name: 'User', 
  roles: ['admin'], 
  password: 'administrator',
  password_confirmation: 'administrator'
)
admin.skip_confirmation!
admin.save!
Product.create(
  name: 'Black Belt Handbook',
  price: 50.0,
  quantity: 295,
  pack_size: 5,
  initial_cost: 1.245,
  type: 'Book'
)
Product.create(
  name: 'Color Belt Handbook',
  price: 25.0,
  quantity: 150,
  pack_size: 5,
  initial_cost: 1.728,
  type: 'Book'
)
Product.create(
  name: 'Etiquette Handbook',
  price: 40.0,
  quantity: 25,
  pack_size: 5,
  initial_cost: 7.5,
  type: 'Book'
)
Product.create(
  name: 'Korean Translation Handbook',
  price: 38.0,
  quantity: 2,
  pack_size: 2,
  initial_cost: 10.0,
  type: 'Book'
)
Product.create(
  name: 'Pattern History Handbook',
  price: 40.0,
  quantity: 10,
  pack_size: 5,
  initial_cost: 1.245,
  type: 'Book'
)
Product.create(
  name: 'Tournament Rules Handbook',
  price: 40.0,
  quantity: 23,
  pack_size: 5,
  initial_cost: 2.82,
  type: 'Book'
)
Product.create(
  name: 'How to Measure Stances',
  price: 13.5,
  quantity: 22,
  pack_size: 3,
  initial_cost: 4.0,
  type: 'Book'
)
Product.create(
  name: 'Black Belt Handbook',
  price: 50.0,
  quantity: 59,
  pack_size: 5,
  initial_cost: 1.245,
  type: 'Book'
)
Product.create(
  name: 'YCTA Patch',
  price: 20.0,
  quantity: 318,
  pack_size: 5,
  initial_cost: 0.950,
  type: 'Patch'
)
Product.create(
  name: 'Referee Rocker A (Black)',
  price: 8.0,
  quantity: 100,
  pack_size: 5,
  initial_cost: 1.033,
  type: 'Patch'
)
Product.create(
  name: 'Referee Rocker B (Red)',
  price: 8.0,
  quantity: 100,
  pack_size: 5,
  initial_cost: 1.033,
  type: 'Patch'
)
Product.create(
  name: 'Referee Rocker C (Blue)',
  price: 8.0,
  quantity: 100,
  pack_size: 5,
  initial_cost: 1.033,
  type: 'Patch'
)
Product.create(
  name: 'Car Sticker',
  price: 10.0,
  quantity: 41,
  pack_size: 5,
  initial_cost: 1.0,
  type: 'Printed Material'
)
Product.create(
  name: 'Gup Certificates',
  price: 45.0,
  quantity: 0,
  pack_size: 100,
  initial_cost: 0.0,
  type: 'Printed Material'
)
Product.create(
  name: 'Black Belt Lapel Pins',
  price: 15.0,
  quantity: 169,
  pack_size: 5,
  initial_cost: 1.402,
  type: 'Other'
)
Product.create(
  name: 'Watches (Men\'s)',
  price: 44.99,
  quantity: 10,
  pack_size: 1,
  initial_cost: 13.582,
  type: 'Other'
)
Product.create(
  name: 'Watches (Women\'s)',
  price: 44.99,
  quantity: 11,
  pack_size: 1,
  initial_cost: 13.582,
  type: 'Other'
)
