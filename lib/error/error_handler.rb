module Error
  # ErrorHandler contains the logic for handling exceptions in controllers
  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from StandardError do |exception|
          if ENV['RACK_ENV'] == 'development'
            json_response('Internal Error', exception, 500)
          else
            json_response('Internal Error', 'Unexpected Error', 500)
          end
        end
        rescue_from WebError do |err|
          json_response(err.message, err.error, err.status)
        end
      end
    end

    def json_response(message, error, status)
      render json: { message: message, error: error }, status: status
    end
  end
end
