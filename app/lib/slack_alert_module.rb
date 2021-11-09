module SlackAlertModule
  require 'slack/incoming/webhooks'

  # 유저 가입
  def self.user_signin(user_params)
    slack = Slack::Incoming::Webhooks.new ENV['SLACK_BOT_URL']
    text =
      "*새로운 회원이 가입하였습니다.* 이름 : #{user_params['first_name']} #{user_params['last_name']}, 생일 : #{user_params['date_of_birth(1i)']}-#{user_params['date_of_birth(2i)']}-#{user_params['date_of_birth(3i)']}"
    slack.post text
  end

  # 유저 탈퇴
  def self.user_withdrawal(elem)
    slack = Slack::Incoming::Webhooks.new ENV['SLACK_BOT_URL']
    text = "유저 *#{elem.first_name} #{elem.last_name}* 가 *탈퇴하였습니다.*"
    slack.post text
  end

  # 책 생성
  def self.generate_book(elem, user_params)
    slack = Slack::Incoming::Webhooks.new ENV['SLACK_BOT_URL']
    text =
      "유저 *#{elem['first_name']} #{elem['last_name']}* 가 새로운 책 *#{user_params['title']}* 을 추가하였습니다."
    slack.post text
  end

  # 책 삭제
  def self.delete_book(elem, deletebook)
    slack = Slack::Incoming::Webhooks.new ENV['SLACK_BOT_URL']
    text =
      "유저 *#{elem['first_name']} #{elem['last_name']}* 가 책 *#{deletebook}* 을 삭제하였습니다."
    slack.post text
  end

  # 에러 발생 시 에러코드, 에러 내용 슬랙 메세지로 전송
  def self.alert_error(status_code, error_message)
    slack = Slack::Incoming::Webhooks.new ENV['SLACK_BOT_URL']
    text =
      "에러코드 #{status_code}의 에러가 발생하였습니다. 에러 내용 : #{error_message}"
    slack.post text
  end
end
