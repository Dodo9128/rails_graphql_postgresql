module Mutations
  module Users
    class UpdateUser < ::Mutations::BaseMutation
      argument :id, Integer, required: true
      argument :first_name, String, required: false
      argument :last_name, String, required: false
      argument :date_of_birth, String, required: false

      type Types::AuthorType

      def resolve(id:, **attributes)
        begin
          update_user = Author.find_by(id: id)

          raise Errors::NotFound if update_user.nil?

          update_user.update!(attributes)

          # 마지막은 graphQL 결과물이어야 한다
          update_user
        rescue => exception
          Rails.logger.info exception
          SlackAlertModule.alert_error(
            exception.error_code,
            exception.message,
            exception,
          )
          raise Errors.gql_error!(exception.error_code, exception.message)
        end
      end
    end
  end
end
