class SigninController < ApplicationController
  def index
    @users = Author.all
  end

  def new
    @user = Author.new
  end

  def create
    @newuser = Author.new(user_params)

    respond_to do |format|
      if @newuser.save
        format.html do
          redirect_to @newuser, notice: '가입 was successfully created.'
        end
        format.json { render :show, status: :created, location: @newuser }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: @newuser.errors, status: :unprocessable_entity
        end
      end
    end

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

      # {
      #   "Content-type" : "application/json",
      #   "Authorization" : "Bearer xoxb-2685224176675-2681655594119-HBpigG01WHKqvj4J7Son3qKA"
      # }

      # req.body = "{ 'text' : '<!channel> *새로운 노트가 생성되었습니다.* 제목 : #{note_params["title"]}, 내용 : #{note_params["context"]}'}"
      text = 'text'
      context =
        "*새로운 회원이 가입하였습니다.* 이름 : #{user_params['first_name']} #{user_params['last_name']}, 생일 : #{user_params['date_of_birth(1i)']}-#{user_params['date_of_birth(2i)']}-#{user_params['date_of_birth(3i)']}"

      req.body = { text: context }.to_json
      http.request(req)
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = Author.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.permit(:first_name, :last_name, :date_of_birth)
  end
end
