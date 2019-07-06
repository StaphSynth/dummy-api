module DefaultResponses
  def respond_400
    render json: { error: 'bad request', status: 400 }, status: :bad_request
  end

  def respond_404
    render json: { error: 'record not found', status: 404 }, status: :not_found
  end
end
