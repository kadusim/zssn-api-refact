module ExceptionHandler
  extend ActiveSupport::Concern

  class SurviroIsInfected     < StandardError; end
  class NoHaveEnoughResources < StandardError; end
  class ResourcesNotMatching  < StandardError; end

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end

    rescue_from ExceptionHandler::SurviroIsInfected do |e|
      json_response({ message: e.message }, :unauthorized)
    end

    rescue_from ExceptionHandler::NoHaveEnoughResources do |e|
      json_response({ message: e.message }, :unauthorized)
    end

    rescue_from ExceptionHandler::ResourcesNotMatching do |e|
      json_response({ message: e.message }, :unauthorized)
    end
  end
end
