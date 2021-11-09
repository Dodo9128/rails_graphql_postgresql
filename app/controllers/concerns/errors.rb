# frozen_string_literal: true

module Errors
  UNAUTHORIZED = 401
  UNAUTHORIZED_MESSAGE = 'Invalid unauthorized'

  REQUIRED_NAME = 'requiredName'
  REQUIRED_NAME_MESSAGE = 'Invalid portfolio name should be exists'

  #   INVALID_ACCESS_TOKEN = 'Invalid Access Token'

  INVALID_REQUEST = 400
  INVALID_REQUEST_MESSAGE = 'Invalid Request'
  INVALID_REQUEST_LIMIT_MESSAGE = 'Invalid Request over limit'
  INVALID_REQUEST_DUPLICATED_MESSAGE = 'Invalid Request duplicated'

  INVALID_USER_ID_MESSAGE = 'Invalid user id'

  INVALID_EXIST = 400
  INVALID_EXIST_MESSAGE = 'Invalid Exist'

  #   INVALID_EXIST_TICKER_SYMBOL = 'Invalid Ticker Symbol Exist'

  FORBIDDEN = 403
  FORBIDDEN_MESSAGE = 'Forbidden'

  NOT_FOUND = 404
  NOT_FOUND_MESSAGE = 'Not found Item'

  OPERATION_ERROR = 500
  OPERATION_ERROR_MESSAGE = 'Operation Error'

  UPLOAD_IMAGE_ERROR = 500
  UPLOAD_IMAGE_ERROR_MESSAGE = 'Upload Image Error'

  INVALID_FILE_EXTENSION_TYPE_MESSAGE = 'Invalid File Extension'

  INVALID_CERT_KEY_MATCHED_MESSAGE = 'Invalid cert key matched error'

  def self.gql_error!(error_code, error_message)
    raise GraphQL::ExecutionError.new(
            error_message,
            extensions: {
              code: error_code,
            },
          )
  end

  def self.get_locale_message(error_message, target)
    "#{error_message} #{target}"
  end

  def self.not_found_message(message, target)
    get_locale_message(message, target)
  end

  class UnAuthorized < StandardError
    puts 'Here is UnAuthorized Error Route'
    def message
      UNAUTHORIZED_MESSAGE
    end

    def error_code
      UNAUTHORIZED
    end
    SlackAlertModule.alert_error(UNAUTHORIZED, UNAUTHORIZED_MESSAGE)
  end

  class Forbidden < StandardError
    def message
      FORBIDDEN_MESSAGE
    end

    def error_code
      FORBIDDEN
    end
  end

  class MembershipTerminationRequestedStatus < StandardError
    def message
      I18n.t(:'errors.membership_termination_requested_status')
    end

    def error_code
      UNAUTHORIZED
    end
  end

  class InvalidRequest < StandardError
    def message
      INVALID_REQUEST_MESSAGE
    end

    def error_code
      INVALID_REQUEST
    end
  end

  class InvalidUserId < StandardError
    def message
      INVALID_USER_ID_MESSAGE
    end

    def error_code
      INVALID_REQUEST
    end
  end

  class InvalidExist < StandardError
    def message
      INVALID_EXIST_MESSAGE
    end

    def error_code
      INVALID_EXIST
    end
  end

  class InvalidOperation < StandardError
    def message; end

    def error_code
      OPERATION_ERROR
    end
  end
end
