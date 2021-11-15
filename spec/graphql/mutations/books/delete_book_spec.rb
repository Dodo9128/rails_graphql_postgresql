require 'rails_helper'

module Mutations
  module Books
    RSpec.describe DeleteBook, type: :request do
      describe 'GraphQL_RSpec_Test_Book' do
        it 'delete_book' do
          author = create(:author)

          # 먼저 생성을 해야 삭제할 수 있다 (test 환경이기 때문)
          post '/graphql',
               params: {
                 query: createBookQuery(author_id: author.id),
               }
          json = JSON.parse(response.body)
          data = json['data']['createBook']

          # 책 제대로 생성되었는지 확인하는 로직
          expect(data).to include(
            'id' => be_present,
            'title' => 'This is Testbook',
            'publicationDate' => 1984,
            'genre' => 'Harry_Potter',
            'author' => {
              'id' => author.id.to_s,
            },
          )

          # 삭제 요청
          post '/graphql',
               params: {
                 query: deleteBookQuery(id: data['id'], author_id: author.id),
               }
          second_json = JSON.parse(response.body)

          # 삭제 실행된 response => 삭제 실행된 book의 자료
          second_data = second_json['data']['deleteBook']

          # deleted_at update 여부 확인하려면 Book 모델에서 id 기반으로 찾아 deleted_at.nil? 을 조회해야 함
          search_book = Book.find_by(id: second_data['id'])

          # 삭제 실행 이후 해당 book을 다시 조회했을 때 deleted_at.nil? 이 아니어야 한다
          expect(search_book['deleted_at']).not_to be_nil

          # 나머지 자료 그대로 존재하는지 => Soft Delete 실행되었는지 확인
          expect(second_data).to include(
            # id는 변하지 않아야 하니까 그대로 이전의 id로 판별
            'id' => data['id'],
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

      def deleteBookQuery(id:, author_id:)
        <<~GQL
        mutation {
            deleteBook(
                id: #{id}
                authorId: #{author_id}
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
