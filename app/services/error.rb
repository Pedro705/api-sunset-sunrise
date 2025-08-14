class Error < StandardError
  STATUS_CODE_TO_SYMBOL = {
    400 => :bad_request,
    401 => :unauthorized,
    403 => :forbidden,
    404 => :not_found,
    422 => :unprocessable_entity,
    500 => :internal_server_error,
    502 => :bad_gateway,
    503 => :service_unavailable,
    504 => :gateway_timeout
  }

  attr_reader :message, :details, :status_code

  def initialize(message, details: nil, status_code: nil)
    @message = message
    @details = details
    
    @status_code = if status_code.is_a?(Integer) || status_code.is_a?(String)
      STATUS_CODE_TO_SYMBOL[status_code.to_i] || :internal_server_error
    elsif status_code.is_a?(Symbol)
      status_code
    else
      :internal_server_error
    end
  end
end