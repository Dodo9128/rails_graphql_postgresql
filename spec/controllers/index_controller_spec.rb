require 'rails_helper'

RSpec.describe IndexController, type: :controller do
  describe 'index_controller test' do
    it '#author_list' do
      get :author_list
      expect(response).to have_http_status(:ok)
      expect(assigns(:users)).not_to be_nil
    end
  end
end
