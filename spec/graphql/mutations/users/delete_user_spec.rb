require 'rails_helper'

module Mutations
  module Users
    RSpec.describe DeleteUser, type: :request do
      describe 'GraphQL_RSpec_Test_User' do
        it 'createUser' do
          post '/graphql',
               params: {
                 query:
                   createUserQuery(
                     first_name: 'Test',
                     last_name: 'User',
                     date_of_birth: '1988-08-23',
                   ),
               }

          # JSON.parse 를 했지만 JSON이 아니라 Hash
          # JSON 형식으로 사용하고 싶으면 json.to_json
          # 타입 확인하고 싶으면 .class <= 꿀팁
          json = JSON.parse(response.body)
          data = json['data']['createUser']

          expect(data).to include(
            'firstName' => 'Test',
            'lastName' => 'User',
            'dateOfBirth' => '1988-08-23',
          )
        end

        it 'deleteUser_has no book' do
          post '/graphql',
               params: {
                 query:
                   createUserQuery(
                     first_name: 'Test',
                     last_name: 'User',
                     date_of_birth: '1988-08-23',
                   ),
               }

          json = JSON.parse(response.body)
          data = json['data']['createUser']

          created_user =
            Author.find_by(
              first_name: data['firstName'],
              last_name: data['lastName'],
              date_of_birth: data['dateOfBirth'],
            )

          post '/graphql',
               params: {
                 query: deleteUserQuery(id: created_user['id']),
               }

          delete_user_json = JSON.parse(response.body)

          delete_user_data = delete_user_json['data']['deleteUser']

          puts delete_user_data

          expect(delete_user_data).to include(
            'firstName' => 'Test',
            'lastName' => 'User',
            'dateOfBirth' => '1988-08-23',
          )

          delete_user = Author.find_by(id: created_user['id'])

          expect(delete_user['deleted_at']).not_to be_nil
        end

        it 'deleteUser_has book' do
          post '/graphql',
               params: {
                 query:
                   createUserQuery(
                     first_name: 'Test',
                     last_name: 'User',
                     date_of_birth: '1988-08-23',
                   ),
               }

          json = JSON.parse(response.body)
          data = json['data']['createUser']

          created_user =
            Author.find_by(
              first_name: data['firstName'],
              last_name: data['lastName'],
              date_of_birth: data['dateOfBirth'],
            )

          # 만들어진 유저에게 책 추가
          post '/graphql',
               params: {
                 query: createBookQuery(author_id: created_user.id),
               }

          create_book_json = JSON.parse(response.body)
          create_book_data = create_book_json['data']['createBook']

          # 이제 유저 삭제
          post '/graphql',
               params: {
                 query: deleteUserQuery(id: created_user['id']),
               }

          delete_user_json = JSON.parse(response.body)

          # 삭제한 유저
          delete_user_data = delete_user_json['data']['deleteUser']

          # 삭제한 유저의 정보는 그대로여야 한다(Soft Delete)
          expect(delete_user_data).to include(
            'firstName' => 'Test',
            'lastName' => 'User',
            'dateOfBirth' => '1988-08-23',
          )

          delete_user = Author.find_by(id: created_user['id'])

          # Soft Delete 완료되었는지 확인
          expect(delete_user['deleted_at']).not_to be_nil

          # 유저 탈퇴하면 유저가 가지고 있는 책들까지 삭제되는지 알아보는 로직
          # 책 생성 시 부여받은 id로 검색한다
          deleted_users_book = Book.find_by(id: create_book_data['id'])

          # 지워진 책의 소유자가 삭제한 유저로 지정되어 있는지 확인
          expect(deleted_users_book['author_id']).to eq(delete_user['id'])

          # 유저를 삭제하면서 책의 Soft_delete도 완료되었는지 확인
          expect(deleted_users_book['deleted_at']).not_to be_nil
        end
      end

      # insert query zone

      # CreateUser
      def createUserQuery(first_name:, last_name:, date_of_birth:)
        <<~GQL
        mutation {
            createUser(
                firstName: "#{first_name}"
                lastName: "#{last_name}"
                dateOfBirth: "#{date_of_birth}"
                ) {
                    firstName
                    lastName
                    dateOfBirth
                }
            }
            GQL
      end

      # DeleteUser
      def deleteUserQuery(id:)
        <<~GQL
        mutation {
            deleteUser(
                id: #{id}
            ) {
                firstName
                lastName
                dateOfBirth
            }
        }
        GQL
      end

      # CreateBook
      def createBookQuery(author_id:)
        <<~GQL
          mutation {
            createBook(
              authorId: #{author_id} 
              title: "This is Testbook"
              publicationDate: 1984
              genre: Harry_Potter
            ) {
              id
              title
              publicationDate
              genre
              author {
                id
              }
            }
          }
        GQL
      end
    end
  end
end
