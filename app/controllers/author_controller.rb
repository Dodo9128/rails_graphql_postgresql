class AuthorController < ApplicationController
  def index
    @user = Author.find_by(id: params[:id])

    if @user.nil?
      SlackAlertModule.alert_error(
        Errors::NOT_FOUND,
        Errors::NOT_FOUND_MESSAGE,
        Errors::NOT_FOUND_MESSAGE,
      )
      raise Errors::NotFound
    end

    @books =
      Book.where('author_id = ?', @user.id).where(deleted_at: nil).order(:id)
    if @books.nil?
      SlackAlertModule.alert_error(
        Errors::NOT_FOUND,
        Errors::NOT_FOUND_MESSAGE,
        Errors::NOT_FOUND_MESSAGE,
      )
      raise Errors::NotFound
    end
  end

  def withdrawal
    user = Author.find_by(id: params[:id])
    if user.nil?
      SlackAlertModule.alert_error(
        Errors::NOT_FOUND,
        Errors::NOT_FOUND_MESSAGE,
        Errors::NOT_FOUND_MESSAGE,
      )
      raise Errors::NotFound
    end

    user.update(deleted_at: Time.now.strftime('%Y-%m-%d'))

    # user 삭제 시 user가 가진 book도 함께 삭제

    userbooks = Book.where('author_id = ?', user.id)
    if userbooks.nil?
      SlackAlertModule.alert_error(
        Errors::NOT_FOUND,
        Errors::NOT_FOUND_MESSAGE,
        Errors::NOT_FOUND_MESSAGE,
      )
      raise Errors::NotFound
    end

    userbooks.each do |userbook|
      userbook.update(deleted_at: Time.now.strftime('%Y-%m-%d'))
    end

    respond_to do |format|
      format.html do
        redirect_to '/author', notice: 'User was successfully soft-deleted.'
      end
      format.json do
        render json: {
                 data: {
                   user: "#{user.first_name} #{user.last_name}",
                   message:
                     "user #{user.first_name} #{user.last_name} has deleted",
                 },
               }
      end
    end
    SlackAlertModule.user_withdrawal(user)
  end

  def userinfo
    @user = Author.find_by(id: params[:id])
    if @user.nil?
      SlackAlertModule.alert_error(
        Errors::NOT_FOUND,
        Errors::NOT_FOUND_MESSAGE,
        Errors::NOT_FOUND_MESSAGE,
      )
      raise Errors::NotFound
    end
  end

  def update_info
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
    for elem in user_params
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

    change_first_name = user_params['first_name']
    change_last_name = user_params['last_name']
    change_date_of_birth =
      "#{user_params['date_of_birth(1i)']}-#{user_params['date_of_birth(2i)']}-#{user_params['date_of_birth(3i)']}"

    user.update(
      first_name: change_first_name,
      last_name: change_last_name,
      date_of_birth: change_date_of_birth,
    )

    respond_to do |format|
      format.html do
        redirect_to '/author', notice: 'UserInfo update was success.'
      end
    end
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :date_of_birth)
  end
end
