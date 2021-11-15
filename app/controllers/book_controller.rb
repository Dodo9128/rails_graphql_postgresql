class BookController < ApplicationController
  def index
    user = Author.find_by(id: params[:id])
    if user.nil?
      SlackAlertModule.alert_error(
        Errors::NOT_FOUND,
        Errors::NOT_FOUND_MESSAGE,
        Errors::NOT_FOUND_MESSAGE,
      )
      raise Errors::NotFound
    end
  end

  def new
    user = Author.find_by(id: params[:id])
    if user.nil?
      SlackAlertModule.alert_error(
        Errors::NOT_FOUND,
        Errors::NOT_FOUND_MESSAGE,
        Errors::NOT_FOUND_MESSAGE,
      )
      raise Errors::NotFound
    end
  end

  def create
    user = Author.find_by(id: params[:id])
    if user.nil?
      SlackAlertModule.alert_error(
        Errors::NOT_FOUND,
        Errors::NOT_FOUND_MESSAGE,
        Errors::NOT_FOUND_MESSAGE,
      )
      raise Errors::NotFound
    end

    # 입력받은 모든 params 유효한지 확인
    for elem in book_params
      if elem[1].length == 0
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }
          format.json do
            render json: newbook.errors, status: :unprocessable_entity
          end
          SlackAlertModule.alert_error(
            Errors::NOT_FOUND,
            Errors::NOT_FOUND_MESSAGE,
            Errors::NOT_FOUND_MESSAGE,
          )
          raise Errors::NotFound
        end
      end
    end

    newbook = Book.new(book_params)

    respond_to do |format|
      if newbook.save
        format.html { redirect_to "/author/#{user.id}" }
        format.json do
          render json: {
                   show: {},
                   status: :created,
                   location: "/author/#{user.id}",
                   data: {
                     message:
                       "#{user['first_name']} #{user['last_name']}'s Book was successfully soft-deleted.",
                   },
                 }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: newbook.errors, status: :unprocessable_entity
        end
        SlackAlertModule.alert_error(
          Errors::NOT_FOUND,
          Errors::NOT_FOUND_MESSAGE,
          Errors::NOT_FOUND_MESSAGE,
        )
        raise Errors::NotFound
      end
    end
    SlackAlertModule.generate_book(user, book_params)
  end

  def before_update
    @user = Author.find_by(id: params[:id])
    if @user.nil?
      SlackAlertModule.alert_error(
        Errors::NOT_FOUND,
        Errors::NOT_FOUND_MESSAGE,
        Errors::NOT_FOUND_MESSAGE,
      )
      raise Errors::NotFound
    end
    @book = Book.find_by(id: params[:book_id])
    if @book.nil?
      SlackAlertModule.alert_error(
        Errors::NOT_FOUND,
        Errors::NOT_FOUND_MESSAGE,
        Errors::NOT_FOUND_MESSAGE,
      )
      raise Errors::NotFound
    end
  end

  def update_book_info
    user = Author.find_by(id: params[:id])
    if user.nil?
      SlackAlertModule.alert_error(
        Errors::NOT_FOUND,
        Errors::NOT_FOUND_MESSAGE,
        Errors::NOT_FOUND_MESSAGE,
      )
      raise Errors::NotFound
    end

    book = Book.find_by(id: params[:book_id])
    if book.nil?
      SlackAlertModule.alert_error(
        Errors::NOT_FOUND,
        Errors::NOT_FOUND_MESSAGE,
        Errors::NOT_FOUND_MESSAGE,
      )
      raise Errors::NotFound
    end

    # 입력받은 모든 params 유효한지 확인
    for elem in book_params
      if elem[1].length == 0
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }
          format.json do
            render json: newbook.errors, status: :unprocessable_entity
          end
          SlackAlertModule.alert_error(
            Errors::NOT_FOUND,
            Errors::NOT_FOUND_MESSAGE,
            Errors::NOT_FOUND_MESSAGE,
          )
          raise Errors::NotFound
        end
      end
    end

    change_title = book_params['title']
    change_genre = book_params['genre']
    change_publication_date = book_params['publication_date']

    book.update(
      title: change_title,
      genre: change_genre,
      publication_date: change_publication_date,
    )

    respond_to do |format|
      format.html { redirect_to "/author/#{user.id}" }
      format.json do
        render json: {
                 data: {
                   message:
                     "#{user['first_name']} #{user['last_name']}'s Book has updated.",
                 },
               }
      end
    end
  end

  def delete
    user = Author.find_by(id: params[:id])
    if user.nil?
      SlackAlertModule.alert_error(
        Errors::NOT_FOUND,
        Errors::NOT_FOUND_MESSAGE,
        Errors::NOT_FOUND_MESSAGE,
      )
      raise Errors::NotFound
    end

    book = Book.find_by(id: params[:book_id])
    if book.nil?
      SlackAlertModule.alert_error(
        Errors::NOT_FOUND,
        Errors::NOT_FOUND_MESSAGE,
        Errors::NOT_FOUND_MESSAGE,
      )
      raise Errors::NotFound
    end

    deletebook = book['title']

    book.update(deleted_at: Time.now.strftime('%Y-%m-%d'))

    respond_to do |format|
      format.html { redirect_to "/author/#{user.id}" }
      format.json do
        render json: {
                 data: {
                   message:
                     "#{user['first_name']} #{user['last_name']}'s Book was successfully soft-deleted.",
                 },
               }
      end
    end
    SlackAlertModule.delete_book(user, deletebook)
  end

  private

  def book_params
    params.permit(:title, :publication_date, :genre, :author_id)
  end
end
