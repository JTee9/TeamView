class TeamsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_team, only: [:show, :update_squad]
  
  # Available leagues
  LEAGUES = {
    'Premier League' => { id: 39, name: 'Premier League' },
    'La Liga' => { id: 140, name: 'La Liga' },
    'Serie A' => { id: 135, name: 'Serie A' },
    'Bundesliga' => { id: 78, name: 'Bundesliga' },
    'Ligue 1' => { id: 61, name: 'Ligue 1' },
    'J1 League' => { id: 98, name: 'J1 League' },
    'J2 League' => { id: 99, name: 'J2 League' },
    'J3 League' => { id: 100, name: 'J3 League' }
  }

  def index
    # Get selected league from params, default to Premier League
    @selected_league = params[:league] || 'Premier League'
    @teams = Team.where(league: @selected_league).order(rank: :asc)
    @available_leagues = LEAGUES.keys
  end
  
  def show
    @players = @team.players.order(:shirt_number)
  end
  
  # Manual update buttons
  def update_standings
    league_name = params[:league] || 'Premier League'
    league_config = LEAGUES[league_name]
    
    unless league_config
      redirect_to teams_path, alert: "❌ Unknown league: #{league_name}"
      return
    end
    
    # Add checkbox parameter for fetching squads
    fetch_squads = params[:fetch_squads] == '1'
    
    service = ApiFootballService.new(
      league_id: league_config[:id],
      season: 2024,
      league_name: league_config[:name]
    )
    
    result = service.update_standings(current_user, clear_existing: false, fetch_squads: fetch_squads)
    
    if result[:success]
      message = "✅ Updated #{result[:teams_count]} teams for #{league_name}!"
      message += " Squads updated too!" if fetch_squads
      redirect_to teams_path(league: league_name), notice: message
    else
      redirect_to teams_path, alert: "❌ Update failed: #{result[:error]}"
    end
  end
  
  def update_squad
    service = ApiFootballService.new
    result = service.update_squad(@team)
    
    if result[:success]
      redirect_to @team, notice: "✅ Updated #{result[:players_count]} players!"
    else
      redirect_to @team, alert: "❌ Update failed: #{result[:error]}"
    end
  end
  
  private
  
  def set_team
    @team = Team.find(params[:id])
  end
end