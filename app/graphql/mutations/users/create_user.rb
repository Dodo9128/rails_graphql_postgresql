module Mutations
  module Users
    class CreateUser < ::Mutations::BaseMutation
      argument :first_name, String, required: true
      argument :last_name, String, required: true
      argument :date_of_birth, String, required: true

      type Types::AuthorType

      def resolve(**attributes)
        begin
          newuser =
            Author.create!(
              first_name: attributes[:first_name],
              last_name: attributes[:last_name],
              date_of_birth: attributes[:date_of_birth],
            )

          # 유저정보 없을 시 에러 도출

          raise GraphQL::StandardError if newuser.nil?

          # 메세지 담긴 객체 만들어서 Slack Alert 처리
          messageObj = {
            first_name: attributes[:first_name],
            last_name: attributes[:last_name],
            date_of_birth: attributes[:date_of_birth],
          }
          SlackAlertModule.user_signin(messageObj)

          # 마지막은 graphQL 결과물이어야 한다

          newuser
        rescue => exception
          Rails.logger.info exception
          SlackAlertModule.alert_error(
            Errors::NOT_FOUND,
            Errors::NOT_FOUND_MESSAGE,
            exception,
          )
          raise exception
        end
      end
    end
  end
end
