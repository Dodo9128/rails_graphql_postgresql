# coding utf-8

class IndexController < ApplicationController
    def index
        @msg = "Hello World"
    end

    def authorList
        @users = Author.all
    end
end