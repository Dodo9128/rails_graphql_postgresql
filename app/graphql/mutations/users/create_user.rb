module Mutations
  module Users
    class CreateUser < ::Mutations::BaseMutation
      argument :first_name, String, required: true
      argument :last_name, String, required: true
      argument :date_of_birth, String, required: true

      type Types::AuthorType

      # def resolve(first_name: nil, last_name: nil, date_of_birth: nil)
      #   newuser =
      #     Author.create!(
      #       first_name: first_name,
      #       last_name: last_name,
      #       date_of_birth: date_of_birth,
      #     )

      #   # 메세지 담긴 객체 만들어서 Slack Alert 처리
      #   messageObj = {
      #     first_name: first_name,
      #     last_name: last_name,
      #     date_of_birth: date_of_birth,
      #   }
      #   SlackAlertModule.user_signin(messageObj)

      #   # 마지막은 graphQL 결과물이어야 한다
      #   newuser
      # end

      def resolve(**attributes)
        newuser =
          Author.create!(
            first_name: attributes[:first_name],
            last_name: attributes[:last_name],
            date_of_birth: attributes[:date_of_birth],
          )

        # 메세지 담긴 객체 만들어서 Slack Alert 처리
        messageObj = {
          first_name: attributes[:first_name],
          last_name: attributes[:last_name],
          date_of_birth: attributes[:date_of_birth],
        }
        SlackAlertModule.user_signin(messageObj)

        # 마지막은 graphQL 결과물이어야 한다
        newuser
      end
    end
  end
end
