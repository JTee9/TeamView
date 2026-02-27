# Clear existing data
Team.destroy_all
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

# Create sample teams
Team.create!([
  {
    teamname: "TBFC",
    division: "Division 4 Group D",
    captain: "Jason Talbot",
    motto: "Live Free or Die Hard",
    user: user1
  },
  {
    teamname: "INTENCITY",
    division: "Division 4 Group D",
    captain: "Takashi Yamada",
    motto: "Just kick it up to 11",
    user: user1
  }
])

puts "✅ Created #{User.count} users and #{Team.count} teams!"