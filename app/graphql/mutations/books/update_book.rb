module Mutations
  module Books
    class UpdateBook < ::Mutations::BaseMutation
      argument :id, Integer, required: true
      argument :title, String, required: false
      argument :author_id, Integer, required: false
      argument :publication_date, Integer, required: false
      argument :genre, Types::Enums::Genre, required: false

      type Types::BookType

      def resolve(id:, **attributes)
        begin
          update_book = Book.find_by(id: id)

          raise Errors::NotFound if update_book.nil?

          update_book.tap { |book| book.update!(attributes) }

          update_book
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
