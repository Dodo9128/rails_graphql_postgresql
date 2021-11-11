module Types
  class MutationType < Types::BaseObject
    field :create_book, mutation: Mutations::Books::CreateBook
    field :update_book, mutation: Mutations::Books::UpdateBook
    field :delete_book, mutation: Mutations::Books::DeleteBook
    field :create_user, mutation: Mutations::Users::CreateUser
    field :delete_user, mutation: Mutations::Users::DeleteUser
    field :update_user, mutation: Mutations::Users::UpdateUser
  end
end
