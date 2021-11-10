require 'rails_helper'

RSpec.describe BookController, type: :controller do
  before (:each) do
    @deleteuser = create(:author, id: 8)
    @deletebook = create(:book, author_id: @deleteuser.id)
  end

  describe 'book_controller test' do
    it '#new' do
      bookuser = create(:author)
      book = create(:book, author_id: bookuser.id)
      get :new, params: { id: bookuser.id }

      expect(book).not_to be_nil
      expect(bookuser).not_to be_nil
    end

    it '#create' do
      bookuser = create(:author)
      book = create(:book, author_id: bookuser.id)

      post :create,
           params: {
             id: bookuser.id,
             title: 'testbook',
             genre: 'testbookgenre',
             publication_date: '1943',
             author_id: book.author_id,
           }

      expect(book).not_to be_nil
      expect(bookuser).not_to be_nil
      expect(response).to have_http_status(:found)
    end

    it '#delete' do
      patch :delete, params: { id: @deleteuser.id, book_id: @deletebook.id }

      expect(@deleteuser).not_to be_nil
      expect(@deletebook).not_to be_nil
    end

    it '#before_update' do
      bookuser = create(:author)
      book = create(:book, author_id: bookuser.id)

      get :before_update, params: { id: bookuser.id, book_id: book.id }

      expect(bookuser).not_to be_nil
      expect(book).not_to be_nil
      expect(response).to have_http_status(:ok)
    end

    it '#update_book_info' do
      bookuser = create(:author)
      book = create(:book, author_id: bookuser.id)

      patch :update_book_info,
            params: {
              id: bookuser.id,
              book_id: book.id,
              title: 'changebook',
              genre: 'changegenre',
              publication_date: '1988',
              author_id: book.author_id,
            }

      expect(bookuser).not_to be_nil
      expect(book).not_to be_nil
      expect(response).to have_http_status(:found)
    end
  end
end
