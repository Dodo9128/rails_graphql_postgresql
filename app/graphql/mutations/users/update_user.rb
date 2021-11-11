module Mutations
  module Users
    class UpdateUser < ::Mutations::BaseMutation
      argument :id, Integer, required: true
      argument :first_name, String, required: false
      argument :last_name, String, required: false
      argument :date_of_birth, String, required: false

      type Types::AuthorType

      def resolve(id:, **attributes)
        update_user = Author.find(id)

        update_user.update!(attributes)

        # 마지막은 graphQL 결과물이어야 한다
        update_user
      end
    end
  end
end
