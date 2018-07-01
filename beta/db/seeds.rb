# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


ActiveRecord::Base.establish_connection(:development_alpha)
alpha_data = ActiveRecord::Base.connection.select_all("SELECT * FROM Users;").to_hash

ActiveRecord::Base.establish_connection(:development)
User.destroy_all
alpha_data.each do |alpha_user|
  user = User.create(id: alpha_user['id'], name: alpha_user['name'])
  user.emails.create(adress: alpha_user['email'])
end

ActiveRecord::Base.connection.select_all("SELECT * FROM Users;").to_hash
