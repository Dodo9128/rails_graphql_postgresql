class BookController < ApplicationController
  def index
    @users = Author.find(params[:id])
  end

  def new
    @user = Author.find(params[:id])
    @book = Book.new
  end

  def create
    @user = Author.find(params[:id])
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
        'xoxb-2685224176675-2681655594119-HBpigG01WHKqvj4J7Son3qKA'

      # {
      #   "Content-type" : "application/json",
      #   "Authorization" : "Bearer xoxb-2685224176675-2681655594119-HBpigG01WHKqvj4J7Son3qKA"
      # }

      # req.body = "{ 'text' : '<!channel> *새로운 노트가 생성되었습니다.* 제목 : #{note_params["title"]}, 내용 : #{note_params["context"]}'}"
      text = 'text'
      context =
        "*유저* #{user_params['first_name']} #{user_params['last_name']} 께서 새로운 책 *#{user_params['title']}* 을 추가하였습니다."

      req.body = { text: context }.to_json
      http.request(req)
    end
    # redirect_to "/author/#{@user.id}"
  end

  private

  def user_params
    params.permit(:title, :publication_date, :genre, :author_id)
  end
end
