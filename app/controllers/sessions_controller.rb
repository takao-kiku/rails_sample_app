class SessionsController < ApplicationController

  def new
  end

  def create 
    # リクエストされたメールアドレスを元にユーザ情報を取得
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      # メールアドレスに紐づくデータが存在する場合かつ、リクエストされたパスワードが一致する場合
      # セッションのリセット
      reset_session
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      # cookies にユーザIDを作成
      log_in user
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      redirect_to user
    else
      # エラーメッセージを作成する
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    # ログインされている場合にログアウトする
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end
end
