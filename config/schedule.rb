# Set timezone to London
set :environment_variable, 'TZ', 'Europe/London'

# Run after Saturday matches - Saturday 11 PM UK time
every :saturday, at: '11:00 pm' do
  rake "football:full_update"
end

# Run after Sunday matches - Sunday 11 PM UK time
every :sunday, at: '11:00 pm' do
  rake "football:full_update"
end

# Run after midweek matches - Wednesday 11 PM UK time
every :wednesday, at: '11:00 pm' do
  rake "football:full_update"
end