require 'rails_helper'

module Mutations
  module Users
    RSpec.describe UpdateUser, type: :request do
      describe 'GraphQL_RSpec_Test_User' do
        it 'is FactoryBot.author works?' do
          author = create(:author)
          expect(author['first_name']).to eq('C. K.')
          expect(author['last_name']).to eq('Louis')
        end

        # 모든 유저정보 변경했을 때
        it 'updateUser_all test' do
          author = create(:author)

          expect(author['first_name']).to eq('C. K.')
          expect(author['last_name']).to eq('Louis')

          post '/graphql',
               params: {
                 query:
                   updateUserQuery_All(
                     id: author.id,
                     first_name: 'Test',
                     last_name: 'User',
                     date_of_birth: '2021-03-31',
                   ),
               }

          update_user = Author.find_by(id: author.id)

          expect(update_user['first_name']).to eq('Test')
          expect(update_user['last_name']).to eq('User')
          expect(update_user['date_of_birth']).to eq(Date.parse('2021-03-31'))
        end

        # FirstName, LastName 변경했을 때
        it 'updateUser_FirstName_LastName test' do
          author = create(:author)
          expect(author['first_name']).to eq('C. K.')
          expect(author['last_name']).to eq('Louis')

          post '/graphql',
               params: {
                 query:
                   updateUserQuery_FirstName_LastName(
                     id: author.id,
                     first_name: 'Test',
                     last_name: 'User',
                   ),
               }

          update_user = Author.find_by(id: author.id)

          expect(update_user['first_name']).to eq('Test')
          expect(update_user['last_name']).to eq('User')
          expect(update_user['date_of_birth']).to eq(Date.parse('1942-02-13'))
        end

        # FirstName, DateOfBirth 변경했을 때
        it 'updateUser_FirstName_DateOfBirth test' do
          author = create(:author)

          expect(author['first_name']).to eq('C. K.')
          expect(author['last_name']).to eq('Louis')

          post '/graphql',
               params: {
                 query:
                   updateUserQuery_FirstName_DateOfBirth(
                     id: author.id,
                     first_name: 'Test',
                     date_of_birth: '2021-03-31',
                   ),
               }

          update_user = Author.find_by(id: author.id)

          expect(update_user['first_name']).to eq('Test')
          expect(update_user['last_name']).to eq('Louis')
          expect(update_user['date_of_birth']).to eq(Date.parse('2021-03-31'))
        end

        # LastName, DateOfBirth 변경했을 때
        it 'updateUser_LastName_DateOfBirth test' do
          author = create(:author)

          expect(author['first_name']).to eq('C. K.')
          expect(author['last_name']).to eq('Louis')

          post '/graphql',
               params: {
                 query:
                   updateUserQuery_LastName_DateOfBirth(
                     id: author.id,
                     last_name: 'User',
                     date_of_birth: '2021-03-31',
                   ),
               }

          update_user = Author.find_by(id: author.id)

          expect(update_user['first_name']).to eq('C. K.')
          expect(update_user['last_name']).to eq('User')
          expect(update_user['date_of_birth']).to eq(Date.parse('2021-03-31'))
        end

        # FirstName 만 변경했을 때
        it 'updateUser_FirstName_only' do
          author = create(:author)

          expect(author['first_name']).to eq('C. K.')
          expect(author['last_name']).to eq('Louis')

          post '/graphql',
               params: {
                 query:
                   updateUserQuery_OnlyFirstName(
                     id: author.id,
                     first_name: 'Test',
                   ),
               }

          update_user = Author.find_by(id: author.id)

          expect(update_user['first_name']).to eq('Test')
          expect(update_user['last_name']).to eq('Louis')
          expect(update_user['date_of_birth']).to eq(Date.parse('1942-02-13'))
        end

        # LastName 만 변경했을 때
        it 'updateUser_lastName_only' do
          author = create(:author)

          expect(author['first_name']).to eq('C. K.')
          expect(author['last_name']).to eq('Louis')

          post '/graphql',
               params: {
                 query:
                   updateUserQuery_OnlyLastName(
                     id: author.id,
                     last_name: 'User',
                   ),
               }

          update_user = Author.find_by(id: author.id)

          expect(update_user['first_name']).to eq('C. K.')
          expect(update_user['last_name']).to eq('User')
          expect(update_user['date_of_birth']).to eq(Date.parse('1942-02-13'))
        end

        # DateOfBirth만 변경했을 때
        it 'updateUser_DateOfBirth_only' do
          author = create(:author)

          expect(author['first_name']).to eq('C. K.')
          expect(author['last_name']).to eq('Louis')

          post '/graphql',
               params: {
                 query:
                   updateUserQuery_OnlyDateOfBirth(
                     id: author.id,
                     date_of_birth: '2021-03-31',
                   ),
               }

          update_user = Author.find_by(id: author.id)

          expect(update_user['first_name']).to eq('C. K.')
          expect(update_user['last_name']).to eq('Louis')
          expect(update_user['date_of_birth']).to eq(Date.parse('2021-03-31'))
        end
      end

      # query zone

      # UpdateUser_모든 요소 포함된 수정
      def updateUserQuery_All(id:, first_name:, last_name:, date_of_birth:)
        <<~GQL
        mutation {
            updateUser(
                id: #{id}
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

      # UpdateUser_firstName만 변경
      def updateUserQuery_OnlyFirstName(id:, first_name:)
        <<~GQL
        mutation {
            updateUser(
                id: #{id}
                firstName: "#{first_name}"
            ) {
                firstName
                lastName
                dateOfBirth
            }
        }
        GQL
      end

      # UpdateUser_lastName만 변경
      def updateUserQuery_OnlyLastName(id:, last_name:)
        <<~GQL
        mutation {
            updateUser(
                id: #{id}
                lastName: "#{last_name}"
            ) {
                firstName
                lastName
                dateOfBirth
            }
        }
        GQL
      end

      # UpdateUser_date_of_birth만 변경
      def updateUserQuery_OnlyDateOfBirth(id:, date_of_birth:)
        <<~GQL
        mutation {
            updateUser(
                id: #{id}
                dateOfBirth: "#{date_of_birth}"
            ) {
                firstName
                lastName
                dateOfBirth
            }
        }
        GQL
      end

      # UpdateUser_firstName, lastName 변경
      def updateUserQuery_FirstName_LastName(id:, first_name:, last_name:)
        <<~GQL
        mutation {
            updateUser(
                id: #{id}
                firstName: "#{first_name}"
                lastName: "#{last_name}"
            ) {
                firstName
                lastName
                dateOfBirth
            }
        }
        GQL
      end

      # UpdateUser_firstName, dateOfBirth 변경
      def updateUserQuery_FirstName_DateOfBirth(
        id:,
        first_name:,
        date_of_birth:
      )
        <<~GQL
        mutation {
            updateUser(
                id: #{id}
                firstName: "#{first_name}"
                dateOfBirth: "#{date_of_birth}"
            ) {
                firstName
                lastName
                dateOfBirth
            }
        }
        GQL
      end

      # UpdateUser_lastName, dateOfBirth 변경
      def updateUserQuery_LastName_DateOfBirth(id:, last_name:, date_of_birth:)
        <<~GQL
        mutation {
            updateUser(
                id: #{id}
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
      # query end
    end
  end
end
