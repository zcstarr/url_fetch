module Error
  class WebError < StandardError
    attr_reader :status, :error, :message
    def initialize(message, error, status)
      @message = message
      @error = error
      @status = status
    end
  end
end
