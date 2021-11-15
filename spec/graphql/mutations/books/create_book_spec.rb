require 'rails_helper'

module Mutations
  module Books
    RSpec.describe CreateBook, type: :request do
      describe 'GraphQL_RSpec_Test_Book' do
        it 'create_book' do
          author = create(:author)

          expect do
            post '/graphql',
                 params: {
                   query: createBookQuery(author_id: author.id),
                 }
          end.to change { Book.count }.by(1)
        end

        it 'returns a book' do
          author = create(:author)

          post '/graphql',
               params: {
                 query: createBookQuery(author_id: author.id),
               }
          json = JSON.parse(response.body)
          data = json['data']['createBook']

          expect(data).to include(
            'id' => be_present,
            'title' => 'This is Testbook',
            'publicationDate' => 1984,
            'genre' => 'Harry_Potter',
            'author' => {
              'id' => author.id.to_s,
            },
          )
        end
      end

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
