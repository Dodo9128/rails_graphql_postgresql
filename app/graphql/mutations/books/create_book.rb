module Mutations
  module Books
    class CreateBook < ::Mutations::BaseMutation
      argument :title, String, required: true
      argument :author_id, Integer, required: true
      argument :publication_date, Integer, required: true
      argument :genre, Types::Enums::Genre, required: true

      #   argument :deleted_at, Integer, required: false

      type Types::BookType

      def resolve(author_id:, **attributes)
        Author.find_by(id: author_id).books.create!(attributes)
      end
    end
  end
end
