module Mutations
  module Books
    class DeleteBook < ::Mutations::BaseMutation
      argument :id, Integer, required: true
      argument :author_id, Integer, required: false
      argument :delete_at, Integer, required: true

      type Types::BookType

      def resolve(id:, **attributes)
        Book.find_by(id: id).update!(attributes)
      end
    end
  end
end
