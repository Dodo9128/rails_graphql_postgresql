module Mutations
  module Books
    class CreateBook < ::Mutations::BaseMutation
      argument :title, String, required: true
      argument :author_id, Integer, required: true
      argument :publication_date, Integer, required: true
      argument :genre, Types::Enums::Genre, required: true

      #  argument :deleted_at, Integer, required: false

      type Types::BookType

      def resolve(author_id:, **attributes)
        begin
          user = Author.find_by(id: author_id)
          newbook = user.books.create!(attributes)

          # 유저 유효성 검사
          raise Errors::NotFound if user.nil?

          # 필요인자 유효성 검사
          raise GraphQL::StandardError if newbook.nil?

          SlackAlertModule.generate_book(user, attributes)

          newbook
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
