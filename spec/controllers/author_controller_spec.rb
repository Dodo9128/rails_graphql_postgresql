require 'rails_helper'

RSpec.describe AuthorController, type: :controller do
  describe 'author_controller test' do
    it '#index' do
      bookuser = create(:author)
      get :index, params: { id: bookuser.id }
      expect(response).to have_http_status(:ok)
      expect(response).not_to have_http_status(401)
      #   ap json_body
    end

    it '#withdrawal' do
      bookuser = create(:author)
      book = create(:book, author_id: bookuser.id)
      expect(book).not_to be_nil
      expect(bookuser).not_to be_nil

      expect(bookuser.deleted_at).to be_nil

      patch :withdrawal, params: { id: bookuser.id }
      expect(response).to have_http_status(:found)
      expect(bookuser).not_to be_nil
      expect(bookuser['books']).to be_nil
    end

    it '#userinfo' do
      user = create(:author)
      book = create(:book, author_id: user.id)
      get :userinfo, params: { id: user.id }
      expect(response).not_to have_http_status(:found)
      expect(book).not_to be_nil
      expect(user).not_to be_nil
    end

    it '#update_info' do
      bookuser = create(:author)
      book = create(:book)
      patch :update_info,
            params: {
              id: bookuser.id,
              first_name: 'change',
              last_name: 'name',
              date_of_birth: '1911-02-02',
            }
      expect(response).to have_http_status(:found)
      expect(book).not_to be_nil
      expect(bookuser).not_to be_nil
    end
  end
end
