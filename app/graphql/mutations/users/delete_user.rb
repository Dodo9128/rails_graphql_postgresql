module Mutations
  module Users
    class DeleteUser < ::Mutations::BaseMutation
      argument :id, Integer, required: true

      type Types::AuthorType

      def resolve(id:)
        begin
          delete_user = Author.find_by(id: id)

          # 유저 정보가 없을 때
          raise GraphQL::StandardError if delete_user.nil?

          # 유저가 이미 탈퇴한 유저일 때
          raise Errors::NotFound if delete_user.deleted_at?

          # 유저가 가진 책
          delete_user_books = Book.where('author_id = ?', id)

          # 유저가 가진 책이 없을 시에는 유저의 deleted_at만 업데이트
          if delete_user_books.nil?
            delete_user.update!(
              deleted_at: Time.now.strftime('%Y-%d-%m %H:%M:%S %Z'),
            )
            # 유저가 가진 책이 있을 시 가진 책들의 deleted_at도 함께 업데이트함
          else
            delete_user_books.each do |userbook|
              userbook.update!(
                deleted_at: Time.now.strftime('%Y-%d-%m %H:%M:%S %Z'),
              )
            end
            delete_user.update!(
              deleted_at: Time.now.strftime('%Y-%d-%m %H:%M:%S %Z'),
            )
          end

          SlackAlertModule.user_withdrawal(delete_user)

          # 마지막은 graphQL 결과물이어야 한다
          delete_user
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
