module Mutations
  module Books
    class DeleteBook < ::Mutations::BaseMutation
      argument :id, Integer, required: true
      argument :author_id, Integer, required: true

      # argument :delete_at, Integer, required: true

      type Types::BookType

      def resolve(id:, **attributes)
        begin
          user = Author.find_by(id: attributes[:author_id])

          # 유저 없을 때
          raise Errors::NotFound if user.nil?

          delete_book = Book.find_by(id: id)

          # 이미 삭제된 책일때
          raise Errors::HasDeletedBook if delete_book.deleted_at?

          delete_book.update!(deleted_at: Time.now.strftime('%Y-%m-%d'))

          deletebook_info = { title: delete_book[:title] }

          SlackAlertModule.delete_book(user, deletebook_info)
          delete_book
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
