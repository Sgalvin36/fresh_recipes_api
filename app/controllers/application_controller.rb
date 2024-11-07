class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def authenticate_user
    key = request.headers["Authorization"]
    @user = User.find_by(key: key)

    render json: ErrorSerializer.format_error(ErrorMessage.new("Not logged in.", 405)), status: :method_not_allowed if @user.nil?
  end
  
  private 
  
  def record_not_found(exception)
    render json: ErrorSerializer.format_error(ErrorMessage.new(exception.message, 404)), status: :not_found
  end
end
