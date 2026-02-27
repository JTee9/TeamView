class TeamsController < ApplicationController
  before_action :authenticate_user!, expect: [:index, :show]
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]
  
  def index
    @teams = Team.recent.includes(:user)
  end

  def show
  end

  def new
    @team = Team.new
  end

  def create
    @team = current_user.teams.build(team_params)

    if @team.save
      redirect_to @team, notice: "Team posted successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @team.update(team_params)
      redirect_to @team, notice: "Team updated successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_path, notice: "Team deleted"
  end

  def set_team
    @team = Team.find(params[:id])
  end

  def authorize_user!
    unless @team.user == current_user
      redirect_to teams_path, alert: "Not authorized!"
    end
  end

  def team_params
    params.require(:team).permit(:teamname, :division, :captain, :motto, :players)
  end
end
