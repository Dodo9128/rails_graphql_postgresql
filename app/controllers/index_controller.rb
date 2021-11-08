# coding utf-8

class IndexController < ApplicationController
  def index
    @msg = 'Hello World'
  end

  def author_list
    @users = Author.all.order(:id)
  end
end
