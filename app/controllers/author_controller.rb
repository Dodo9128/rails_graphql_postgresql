class AuthorController < ApplicationController
  def index
    @user = Author.find(params[:id])
    @books =
      Book.where('author_id = ?', @user.id).where(deleted_at: nil).order(:id)
  end

  def withdrawal
    @user = Author.find(params[:id])
    @user.update(deleted_at: Time.now.strftime('%Y-%d-%m %H:%M:%S %Z'))
    @userbooks = Book.where('author_id = ?', @user.id)

    @userbooks.each do |userbook|
      userbook.update(deleted_at: Time.now.strftime('%Y-%d-%m %H:%M:%S %Z'))
    end

    respond_to do |format|
      format.html do
        redirect_to '/author', notice: 'User was successfully soft-deleted.'
      end
      # format.json { head :no_content }
    end

    # Slack Alert logic
    require 'net/http'

    uri =
      URI(
        'https://hooks.slack.com/services/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',
      )

    # Slack_Testing_Alert_Bot_3

    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      req = Net::HTTP::Post.new(uri)
      req.content_type = 'application/json'
      req['Authorization'] =
        'xoxb-2685224176675-2694181314949-Qa3jsnHR80tTMooo0zVW1Gbu'

      text = 'text'
      context =
        "*유저* #{@user.first_name} #{@user.last_name} *님이 탈퇴하였습니다.*"

      req.body = { text: context }.to_json
      http.request(req)
    end
  end

  def userinfo
    @user = Author.find(params[:id])
  end

  def update_info
    @user = Author.find(params[:id])

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
      # format.json { head :no_content }
    end
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :date_of_birth)
  end
end
