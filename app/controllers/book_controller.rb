class BookController < ApplicationController
  def index
    @users = Author.find(params[:id])
  end

  def new
    @user = Author.find_by(id: params[:id])
    @book = Book.new
  end

  def create
    @user = Author.find_by(id: params[:id])
    @newbook = Book.new(user_params)

    respond_to do |format|
      if @newbook.save
        format.html do
          redirect_to "/author/#{@user.id}", notice: '책 생성 완료'
        end
        format.json do
          render :show, status: :created, location: "/author/#{@user.id}"
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: @newbook.errors, status: :unprocessable_entity
        end
      end
    end

    SlackAlertModule.generate_book(@user, user_params)
  end

  def before_update
    @user = Author.find_by(id: params[:id])
    @book = Book.find(params[:book_id])
  end

  def update_book_info
    @user = Author.find_by(id: params[:id])
    @book = Book.find(params[:book_id])

    change_title = user_params['title']
    change_genre = user_params['genre']
    change_publication_date = user_params['publication_date']

    @book.update(
      title: change_title,
      genre: change_genre,
      publication_date: change_publication_date,
    )

    respond_to do |format|
      format.html do
        redirect_to "/author/#{@user.id}", notice: 'Book update was success.'
      end
      # format.json { head :no_content }
    end
  end

  def delete
    @user = Author.find_by(id: params[:id])
    @book = Book.find(params[:book_id])
    deletebook = @book['title']
    @book.update(deleted_at: Time.now.strftime('%Y-%d-%m %H:%M:%S %Z'))

    respond_to do |format|
      format.html do
        redirect_to "/author/#{@user.id}",
                    notice:
                      "#{@user['first_name']} #{@user['last_name']}'s Book was successfully soft-deleted."
      end
    end
    SlackAlertModule.delete_book(@user, deletebook)
  end

  private

  def user_params
    params.permit(:title, :publication_date, :genre, :author_id)
  end
end
