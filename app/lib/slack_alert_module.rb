module SlackAlertModule
  require 'slack/incoming/webhooks'

  # 유저 가입
  def self.user_signin(user_params)
    # graphQL에서 넘어올 때 (user_params type == Hash)

    if user_params.instance_of? Hash
      first_name = user_params[:first_name]
      last_name = user_params[:last_name]
      date_of_birth = user_params[:date_of_birth]

      slack = Slack::Incoming::Webhooks.new ENV['SLACK_BOT_URL']
      text =
        "*새로운 회원이 가입하였습니다.* 이름 : #{first_name} #{last_name}, 생일 : #{date_of_birth}"
      slack.post text

      # REST API 사용 시
    else
      slack = Slack::Incoming::Webhooks.new ENV['SLACK_BOT_URL']
      text =
        "*새로운 회원이 가입하였습니다.* 이름 : #{user_params['first_name']} #{user_params['last_name']}, 생일 : #{user_params['date_of_birth(1i)']}-#{user_params['date_of_birth(2i)']}-#{user_params['date_of_birth(3i)']}"
      slack.post text
    end
  end

  # 유저 탈퇴
  def self.user_withdrawal(user)
    if user.instance_of? Hash
      first_name = user[:first_name]
      last_name = user[:last_name]
      slack = Slack::Incoming::Webhooks.new ENV['SLACK_BOT_URL']
      text = "유저 *#{first_name} #{last_name}* 가 *탈퇴하였습니다.*"
      slack.post text
    else
      slack = Slack::Incoming::Webhooks.new ENV['SLACK_BOT_URL']
      text = "유저 *#{user.first_name} #{user.last_name}* 가 *탈퇴하였습니다.*"
      slack.post text
    end
  end

  # 책 생성
  def self.generate_book(user, book_params)
    if book_params.instance_of? Hash
      title = book_params[:title]
      slack = Slack::Incoming::Webhooks.new ENV['SLACK_BOT_URL']
      text =
        "유저 *#{user['first_name']} #{user['last_name']}* 가 새로운 책 *#{title}* 을 추가하였습니다."
      slack.post text
    else
      slack = Slack::Incoming::Webhooks.new ENV['SLACK_BOT_URL']
      text =
        "유저 *#{user['first_name']} #{user['last_name']}* 가 새로운 책 *#{book_params['title']}* 을 추가하였습니다."
      slack.post text
    end
  end

  # 책 삭제
  def self.delete_book(user, deletebook)
    puts deletebook
    if deletebook.instance_of? Hash
      title = deletebook[:title]
      slack = Slack::Incoming::Webhooks.new ENV['SLACK_BOT_URL']
      text =
        "유저 *#{user['first_name']} #{user['last_name']}* 가 책 *#{title}* 을 삭제하였습니다."
      slack.post text
    else
      slack = Slack::Incoming::Webhooks.new ENV['SLACK_BOT_URL']
      text =
        "유저 *#{user['first_name']} #{user['last_name']}* 가 책 *#{deletebook}* 을 삭제하였습니다."
      slack.post text
    end
  end

  # 에러 발생 시 에러코드, 에러 내용 슬랙 메세지로 전송

  def self.alert_error(status_code, error_message, error_log)
    slack = Slack::Incoming::Webhooks.new ENV['SLACK_BOT_URL']
    text =
      "*에러코드 #{status_code}* 의 *에러가 발생하였습니다.* \n Error Message : #{error_message}, \n Error Log : #{error_log}"
    slack.post text
  end
end
