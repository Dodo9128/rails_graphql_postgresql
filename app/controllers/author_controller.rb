class AuthorController < ApplicationController
  def index
    @user = Author.find_by(id: params[:id])
    raise Errors::UnAuthorized if @user.nil?

    @books =
      Book.where('author_id = ?', @user.id).where(deleted_at: nil).order(:id)
  end

  def withdrawal
    @user = Author.find_by(id: params[:id])
    raise Errors::UnAuthorized if @user.nil?

    @user.update(deleted_at: Time.now.strftime('%Y-%d-%m %H:%M:%S %Z'))

    # user 삭제 시 user가 가진 book도 함께 삭제

    @userbooks = Book.where('author_id = ?', @user.id)
    if @userbooks.nil?
      raise Exception.new "error message: #{@user.first_name} #{@user.last_name} has no books"
    end

    @userbooks.each do |userbook|
      userbook.update(deleted_at: Time.now.strftime('%Y-%d-%m %H:%M:%S %Z'))
    end

    respond_to do |format|
      format.html do
        redirect_to '/author', notice: 'User was successfully soft-deleted.'
      end
      format.json do
        render json: {
                 data: {
                   user: "#{@user.first_name} #{@user.last_name}",
                   message:
                     "user #{@user.first_name} #{@user.last_name} has deleted",
                 },
               }
      end
    end

    # Slack Alert logic

    SlackAlertModule.user_withdrawal(@user)
  end

  def userinfo
    @user = Author.find_by(id: params[:id])
  end

  def update_info
    @user = Author.find_by(id: params[:id])

    change_first_name = user_params['first_name']
    change_last_name = user_params['last_name']
    change_date_of_birth =
      "#{user_params['date_of_birth(1i)']}-#{user_params['date_of_birth(2i)']}-#{user_params['date_of_birth(3i)']}"

    @user.update(
      first_name: change_first_name,
      last_name: change_last_name,
      date_of_birth: change_date_of_birth,
    )

    respond_to do |format|
      format.html do
        redirect_to '/author', notice: 'UserInfo update was success.'
      end
      render json: {
               data: {
                 user: "#{@user.first_name} #{@user.last_name}",
                 message:
                   "user #{@user.first_name} #{@user.last_name} 'info has changed",
               },
             }
    end
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :date_of_birth)
  end
end
