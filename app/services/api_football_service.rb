class ApiFootballService
  include HTTParty
  base_uri 'https://v3.football.api-sports.io'

  PREMIER_LEAGUE_ID = 39
  CURRENT_SEASON= 2024

  def initialize
    @options = {
      headers: {
        'x-rapidapi-key' => ENV['API_FOOTBALL_KEY'],
        'x-rapidapi-host' => 'v3.football.api-sports.io'
      }
    }
  end

  # Fetch and save league standings
  def update_standings(user)
    puts 'Fetching Premier League standings...'

    response = self.class.get(
      '/standings',
      @options.merge(query: { league: PREMIER_LEAGUE_ID, season: CURRENT_SEASON })
    )

    unless response.success?
      puts "❌ API Error: #{response.code} - #{response.message}"
      return { success: false, error: response.message}
    end

    data = response.parsed_response

    unless data['response']&.any?
      puts "❌ No standings data found"
      return { success: false, error: "No data returned from API."}
    end

    standings = data['response'][0]['league']['standings'][0]

    standings.each do |team_data|
      team = Team.find_or_initialize_by(
        api_football_id: team_data['team']['id'].to_s
      )

      team.assign_attributes(
        teamname: team_data['team']['name'],
        logo_url: team_data['team']['logo'],
        league: 'Premier League',
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
        puts "✅ #{team.rank}. #{team.teamname} - #{team.points} pts"
      else
        puts "❌ Failed to save #{team_data['team']['name']}: #{team.errors.full_messages.join(', ')}"
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
      puts "❌ API Error: #{response.code}",
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
        api_football_id: payer_data['id'].to_s,
        team: team
      )

      players.assign_attributes(
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