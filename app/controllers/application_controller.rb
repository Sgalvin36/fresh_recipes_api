class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private 
  
  def record_not_found(exception)
    render json: ErrorSerializer.format_error(ErrorMessage.new(exception.message, 404)), status: :not_found
  end
end
