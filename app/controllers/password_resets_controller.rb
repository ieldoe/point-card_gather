class PasswordResetsController < ApplicationController
  # Rails 5以降では、次の場合にエラーが発生します。
  # before_action :require_login
  # ApplicationControllerで宣言されていません。
  skip_before_action :require_login

  # パスワードリセット申請画面へレンダリングするアクション
  def new; end

  # パスワードのリセットを要求するアクション。
  # ユーザーがパスワードのリセットフォームにメールアドレスを入力して送信すると、このアクションが実行される。
  def create
    @user = User.find_by(email: params[:email])

    # この行は、パスワード（ランダムトークンを含むURL）をリセットする方法を説明した電子メールをユーザーに送信します
    @user&.deliver_reset_password_instructions!
    # 上記は@user.deliver_reset_password_instructions! if @user と同じ

    # 電子メールが見つかったかどうかに関係なく、ユーザーの指示が送信されたことをユーザーに伝えます。
    # これは、システムに存在する電子メールに関する情報を攻撃者に漏らさないためです。
    redirect_to login_path
  end

  # パスワードのリセットフォーム画面へ遷移するアクション
  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])
　　return not_authenticated if @user.blank?
  end

  # ユーザーがパスワードのリセットフォームを送信したときに発生
  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])
    return not_authenticated if @user.blank?

    # 次の行は、パスワード確認の検証を機能させます
    @user.password_confirmation = params[:user][:password_confirmation]
    # 次の行は一時トークンをクリアし、パスワードを更新します
    if @user.change_password(params[:user][:password])
      redirect_to login_path, success: t('.success')
    else
      render :edit
    end
  end

  private

  def deliver_reset_password_instructions!
  mail = false
  config = sorcery_config
  # hammering protection
  return false if config.reset_password_time_between_emails.present? && send(config.reset_password_email_sent_at_attribute_name) && send(config.reset_password_email_sent_at_attribute_name) > config.reset_password_time_between_emails.seconds.ago.utc

  self.class.sorcery_adapter.transaction do
    generate_reset_password_token!
    mail = send_reset_password_email! unless config.reset_password_mailer_disabled
  end
  mail
  end

  def load_from_reset_password_token(token, &block)
  load_from_token(
    token,
    @sorcery_config.reset_password_token_attribute_name,
    @sorcery_config.reset_password_token_expires_at_attribute_name,
    &block
  )
  end

  def change_password(new_password, raise_on_failure: false)
  clear_reset_password_token
  send(:"#{sorcery_config.password_attribute_name}=", new_password)
  sorcery_adapter.save raise_on_failure: raise_on_failure
  end


end
