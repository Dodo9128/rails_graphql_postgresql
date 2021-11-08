# coding utf-8

class IndexController < ApplicationController
  def index
    @msg = "User & User's Book CRUD Practice"
  end

  def author_list
    @users = Author.where(deleted_at: nil).order(:id)
    # @users = Author.all.order(:id)
  end
end
