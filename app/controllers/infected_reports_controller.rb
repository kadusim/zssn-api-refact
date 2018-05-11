class InfectedReportsController < ApplicationController

  before_action :get_survivors_and_check_exists, only: [:create]
  before_action :check_survivors_was_infected,   only: [:create]
  after_action  :set_infected_survivor!,         only: [:create]

  api :POST, 'api/infected_report', 'Flag Survivor as Infected'
  def create
    @infected_report = InfectedReport.create!(infected_report_params)
    json_response({ message: "Survivor reported successfully" }, :created)
  end

  private

  def get_survivors_and_check_exists
    @survivor = Survivor.find(params[:survivor_id])
    @reporter = Survivor.find(params[:reporter_id])
  end

  def check_survivors_was_infected
    head :forbidden if @survivor.infected || @reporter.infected
  end

  def set_infected_survivor!
    if @survivor.maximum_reporting_limit_reached?
      @survivor.infected = true
      @survivor.save!
    end
  end

  def infected_report_params
    params.permit(:survivor_id, :reporter_id)
  end

end
