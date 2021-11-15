require 'rails_helper'

module Mutations
  module Users
    RSpec.describe CreateUser, type: :request do
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
      end

      # 쿼리들 작성하는 구간
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
    end
  end
end
