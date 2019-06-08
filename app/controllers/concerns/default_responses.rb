module DefaultResponses
  def respond_400
    head :bad_request
  end

  def respond_404
    render json: { error: 'record not found', code: 404 }, status: :not_found
  end
end
