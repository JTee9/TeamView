class ApiFootballService
  include HTTParty
  base_uri 'https://v3.football.api-sports.io'

  def initialize(league_id: 39, season: 2024, league_name: 'Premier League')
    @league_id = league_id
    @season = season
    @league_name = league_name
    @options = {
      headers: {
        'x-rapidapi-key' => ENV['API_FOOTBALL_KEY'],
        'x-rapidapi-host' => 'v3.football.api-sports.io'
      }
    }
  end

  # Fetch and save league standings
  def update_standings(user, clear_existing: false, fetch_squads: false)
  puts "Fetching #{@league_name} standings for season #{@season}..."
  
  # Always clear existing teams for this league before updating
  puts "Clearing existing teams for #{@league_name}..."
  Team.where(league: @league_name).destroy_all
  
  response = self.class.get(
    '/standings',
    @options.merge(query: { league: @league_id, season: @season })
  )
  
  unless response.success?
    puts "❌ API Error: #{response.code} - #{response.message}"
    return { success: false, error: response.message }
  end
  
  data = response.parsed_response
  
  unless data['response']&.any?
    puts "❌ No standings data found"
    return { success: false, error: "No data returned from API" }
  end
  
  standings = data['response'][0]['league']['standings'][0]
  teams_saved = []
  
  standings.each do |team_data|
    team = Team.find_or_initialize_by(
      api_football_id: team_data['team']['id'].to_s
    )
    
    team.assign_attributes(
      teamname: team_data['team']['name'],
      logo_url: team_data['team']['logo'],
      league: @league_name,
      rank: team_data['rank'],
      played: team_data['all']['played'],
      wins: team_data['all']['win'],
      draws: team_data['all']['draw'],
      losses: team_data['all']['lose'],
      goals_for: team_data['all']['goals']['for'],
      goals_against: team_data['all']['goals']['against'],
      goal_difference: team_data['goalsDiff'],
      points: team_data['points'],
      form: team_data['form'],
      last_updated: Time.current,
      user: user
    )
    
    if team.save
      teams_saved << team
      puts "✅ #{team.rank}. #{team.teamname} - #{team.points} pts"
    else
      puts "❌ Failed to save #{team_data['team']['name']}: #{team.errors.full_messages.join(', ')}"
    end
  end
  
  # NEW: Optionally fetch squads after standings
  if fetch_squads && teams_saved.any?
    puts "\n👥 Fetching squads for all teams..."
    teams_saved.each_with_index do |team, index|
      puts "\n[#{index + 1}/#{teams_saved.count}] Updating #{team.teamname}..."
      update_squad(team)
      sleep 1  # Rate limiting
    end
  end
  
  { success: true, teams_count: standings.count }
end

  # Fetch and save squad for a specific team
  def update_squad(team)
    puts "Fetching squad for #{team.teamname}..."

    response = self.class.get(
      '/players/squads',
      @options.merge(query: { team: team.api_football_id })
    )

    unless response.success?
      puts "❌ API Error: #{response.code}"
      return { success: false, error: response.message }
    end

    data = response.parsed_response

    unless data['response']&.any?
      puts "❌ No squad data found"
      return { success: false, error: "No data returned" }
    end

    players_data = data['response'][0]['players']
    saved_count = 0

    players_data.each do |player_data|
      player = Player.find_or_initialize_by(
        api_football_id: player_data['id'].to_s,
        team: team
      )

      player.assign_attributes(
        name: player_data['name'],
        position: player_data['position'],
        shirt_number: player_data['number'],
        age: player_data['age'],
        nationality: nil,  # Not in this endpoint
        market_value: nil, # Not in this endpoint
        last_updated: Time.current
      )

      if player.save
        saved_count += 1
        puts "✅ #{player.shirt_number} #{player.name}"
      end
    end

    puts "✅ Saved #{saved_count} players for #{team.teamname}"
    { success: true, players_count: saved_count}
  end

  # Update all squads for all teams
  def update_all_squads
    puts "Updaing squads for all teams..."

    Team.find_each do |team|
      result = update_squad(team)
      sleep 1 # Rate limiting

      unless result[:success]
        puts "⚠️ Skipped #{team.teamname}: #{result[:error]}"
      end
    end
  end

  # Check API usage
  def check_api_status
    response = self.class.get('/status', @options)

    if response.success?
      data = response.parsed_response['response']
      puts "API Status:"
      puts "Requests today: #{data['requests']['current']}/#{data['requests']['limit_day']}"
      puts "Account: #{data['account']['firstname']} #{data['account']['lastname']}"
      data
    else
      puts "❌ Could not fetch API status"
      nil
    end
  end
end