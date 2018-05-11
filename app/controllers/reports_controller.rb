class ReportsController < ApplicationController

  before_action :check_presence_survivors

  api :GET, 'api/reports/percentage_infected_survivors', 'Percentage of infected survivors'
  def percentage_infected_survivors
    json_response({ percentage: Survivor.total_percentage_infected_survivors })
  end

  api :GET, 'api/reports/percentage_non_infected_survivors', 'Percentage of non infected survivors'
  def percentage_non_infected_survivors
    json_response({ percentage: Survivor.total_percentage_non_infected_survivors })
  end

  api :GET, 'api/reports/average_resources_by_survivor', 'Average Resources By Survivor'
  def average_resources_by_survivor
    json_response({ averages: Survivor.total_average_resources_by_survivor })

  end

  api :GET, 'api/reports/points_lost_because_infected', 'Points lost because of infected survivors'
  def points_lost_because_infected
    json_response({ points_lost: Survivor.total_points_lost_because_infected })

  end

  private

  def check_presence_survivors
    json_response({ message: 'No survivors found' }) if Survivor.none?

  end

end
