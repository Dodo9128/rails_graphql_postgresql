require 'rails_helper'

module Mutations
  module Books
    RSpec.describe UpdateBook, type: :request do
      describe 'GraphQL_RSpec_Test_Book' do
        it 'is Create user & book done?' do
          author = create(:author)
          expect do
            post '/graphql',
                 params: {
                   query: createBookQuery(author_id: author.id),
                 }
          end.to change { Book.count }.by(1)
        end

        it 'is update_book Logic works?' do
          author = create(:author)

          post '/graphql',
               params: {
                 query: createBookQuery(author_id: author.id),
               }

          json = JSON.parse(response.body)
          data = json['data']['createBook']

          # 만들어낸 책
          expect(data).to include(
            'id' => be_present,
            'title' => 'This is Testbook',
            'publicationDate' => 1984,
            'genre' => 'Harry_Potter',
            'author' => {
              'id' => author.id.to_s,
            },
          )

          post '/graphql',
               params: {
                 query: updateBookQuery(id: data['id'], author_id: author.id),
               }

          update_json = JSON.parse(response.body)
          update_data = update_json['data']['updateBook']
          expect(update_data).to include(
            # id는 변하지 않아야 하니까 그대로 이전의 id로 판별
            'id' => data['id'],
            'title' => 'This is Change',
            'publicationDate' => 2021,
            'genre' => 'Horror',
            'author' => {
              'id' => author.id.to_s,
            },
          )
        end
      end

      # 구분선 (쿼리들 작성하는 구간)

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

      def updateBookQuery(id:, author_id:)
        <<~GQL
        mutation {
            updateBook(
                id: #{id}
                authorId: #{author_id}
                title: "This is Change"
                genre: Horror
                publicationDate: 2021
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
