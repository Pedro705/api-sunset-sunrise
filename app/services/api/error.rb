module Api
  class Error < StandardError
    attr_reader :details, :status_code

    def initialize(message, details: nil, status_code: nil)
      super(message)
      @status_code = status_code
      @details = details
    end

    def to_h
        {
            error: message,
            details: details,
            status_code: status_code
        }
    end
  end
end
