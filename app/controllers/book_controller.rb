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
        'xoxb-2685224176675-2694181314949-Qa3jsnHR80tTMooo0zVW1Gbu'

      # req.body = "{ 'text' : '<!channel> *새로운 노트가 생성되었습니다.* 제목 : #{note_params["title"]}, 내용 : #{note_params["context"]}'}"
      text = 'text'
      context =
        "유저 *#{@user['first_name']} #{@user['last_name']}* 께서 새로운 책 *#{user_params['title']}* 을 추가하였습니다."

      req.body = { text: context }.to_json
      http.request(req)
    end
    # redirect_to "/author/#{@user.id}"
  end

  def before_delete
    @user = Author.find(params[:id])
    @book = Book.find(params[:book_id])
  end

  def delete
    @user = Author.find(params[:id])
    @book = Book.find(params[:book_id])
    @book.update(deleted_at: Time.now.strftime('%Y-%d-%m %H:%M:%S %Z'))

    respond_to do |format|
      format.html do
        redirect_to "/author/#{@user.id}",
                    notice:
                      "#{@user['first_name']} #{@user['last_name']}'s Book was successfully soft-deleted."
      end
      # format.json { head :no_content }
    end
  end

  private

  def user_params
    params.permit(:title, :publication_date, :genre, :author_id)
  end
end
