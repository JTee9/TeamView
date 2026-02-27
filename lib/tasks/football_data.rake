namespace :football do
  desc "Update Premier League standings"
  task update_standings: :environment do
    puts "=" * 50
    puts "UPDATING PREMIER LEAGUE STANDINGS"
    puts "=" * 50

    user = User.first || User.create!(
      email: 'admin@teamview.com',
      password: 'password123'
    )

    service = ApiFootballService.new

    # Check API status first
    service.check_api_status

    # Update standings
    result = service.update_standings(user)

    if result[:success]
      puts "\n🎉 Successfully updated #{result[:teams_count]} teams!"
    else
      puts "\n❌ Failed to update standings: #{result[:error]}"
    end
  end

  desc "Update all team squads"
  task update_squads: :environment do
    puts "=" * 50
    puts "UPDATING ALL TEAM SQUADS"
    puts "=" * 50
    
    service = ApiFootballService.new
    service.check_api_status
    service.update_all_squads
    
    puts "\n🎉 Squad update complete!"
  end
  
  desc "Full update - standings and squads"
  task full_update: :environment do
    puts "=" * 50
    puts "FULL DATA UPDATE"
    puts "=" * 50
    
    Rake::Task['football:update_standings'].invoke
    puts "\nWaiting 5 seconds before updating squads..."
    sleep 5
    Rake::Task['football:update_squads'].invoke
    
    puts "\n✅ Full update complete!"
    puts "Last updated: #{Time.current.strftime('%Y-%m-%d %H:%M:%S')}"
  end
  
  desc "Check API status"
  task api_status: :environment do
    service = ApiFootballService.new
    service.check_api_status
  end
end