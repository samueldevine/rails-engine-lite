class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :handle_error_404
  rescue_from ActiveRecord::RecordInvalid, with: :handle_error_400

  private

  def handle_error_404(e)
    render json: { error: e.to_s }, status: :not_found
  end

  def handle_error_400(e)
    render json: { error: e.to_s }, status: :bad_request
  end
end
