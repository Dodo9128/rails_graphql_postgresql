module Mutations
  module Users
    class DeleteUser < ::Mutations::BaseMutation
      argument :id, Integer, required: true

      type Types::AuthorType

      def resolve(id:)
        delete_user = Author.find(id)

        # 책까지 모두 삭제 로직
        delete_user_books = Book.where('author_id = ?', id)

        delete_user_books.each do |userbook|
          userbook.update!(
            deleted_at: Time.now.strftime('%Y-%d-%m %H:%M:%S %Z'),
          )
        end

        # Soft-delete 위한 deleted_at 업데이트
        delete_user.update!(
          deleted_at: Time.now.strftime('%Y-%d-%m %H:%M:%S %Z'),
        )

        # 메세지 담긴 객체 만들어서 Slack Alert 처리
        # messageObj = {
        #   first_name: first_name,
        #   last_name: last_name,
        #   date_of_birth: date_of_birth,
        # }
        SlackAlertModule.user_withdrawal(delete_user)

        # 마지막은 graphQL 결과물이어야 한다
        delete_user
      end
    end
  end
end
