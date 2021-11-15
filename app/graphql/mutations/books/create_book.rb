module Mutations
  module Books
    class CreateBook < ::Mutations::BaseMutation
      argument :title, String, required: true
      argument :author_id, Integer, required: true
      argument :publication_date, Integer, required: true
      argument :genre, Types::Enums::Genre, required: true

      type Types::BookType

      def resolve(author_id:, **attributes)
        begin
          # 유저 유효성 검사
          user = Author.find_by(id: author_id)

          raise Errors::NotFound if user.nil?

          newbook = user.books.create!(attributes)

          # 필요인자 유효성 검사
          raise Errors::InvalidOperation if newbook.nil?

          SlackAlertModule.generate_book(user, attributes)

          newbook
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
