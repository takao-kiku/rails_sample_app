module SessionsHelper

  # 渡されたユーザでログインする
  def log_in(user)
    # セッションにユーザーIDを保存する
    session[:user_id] = user.id
  end

  # 現在ログイン中のユーザーを返却
  def current_user
    if session[:user_id]
      # セッションにユーザIDが存在する場合
      # ユーザID に紐づくユーザの情報を取得
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # 現在のユーザーをログアウトする
  def log_out
    reset_session
    @current_user = nil
  end
end
