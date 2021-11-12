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
          raise GrapuQL::StandareError if delete_book.deleted_at?

          # raise GraphQL::StandardError if delete_book.nil?

          delete_book.update!(
            deleted_at: Time.now.strftime('%Y-%d-%m %H:%M:%S %Z'),
          )

          deletebook_info = { title: delete_book[:title] }

          SlackAlertModule.delete_book(user, deletebook_info)
          delete_book
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
