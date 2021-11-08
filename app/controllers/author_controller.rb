class AuthorController < ApplicationController
  def index
    @user = Author.find(params[:id])
    @books = Book.where('author_id = ?', @user.id)
  end
end
