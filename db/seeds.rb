# Clear existing data
User.destroy_all

# Create test users
user1 = User.create!(
  email: "administrator@example.com",
  password: "password123"
)

user2 = User.create!(
  email: "teamowner@example.com",
  password: "password123"
)

puts "✅ Created user: #{user.email}"
puts "Now run: rails football:update_standings"