class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password_email.subject
  #
  default from: 'from@example.com'
  def reset_password_email
    @user = User.find(user.id)
    @url = edit_password_reset_url(@user.reset_password_token)
    mail(to: user.email, subject: 'パスワードリセット')
  end

  # Generates a reset code with expiration and sends an email to the user.
  def deliver_reset_password_instructions!
    mail = false
    config = sorcery_config
    # hammering protection
    if config.reset_password_time_between_emails.present? && send(config.reset_password_email_sent_at_attribute_name) && send(config.reset_password_email_sent_at_attribute_name) > config.reset_password_time_between_emails.seconds.ago.utc
      return false
    end

    self.class.sorcery_adapter.transaction do
      generate_reset_password_token!
      mail = send_reset_password_email! unless config.reset_password_mailer_disabled
    end
    mail
  end
end
