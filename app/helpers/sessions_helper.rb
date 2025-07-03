module SessionsHelper

  # 渡されたユーザでログインする
  def log_in(user)
    # セッションにユーザーIDを保存する
    session[:user_id] = user.id
    # セッションリプレイ攻撃から保護する
    # 詳しくは https://techracho.bpsinc.jp/hachi8833/2023_06_02/130443 を参照
    session[:session_token] = user.session_token
  end

  # 永続的セッションのためにユーザーをデータベースに記憶する
  def remember(user)
    # user.rb の remember メソッドを呼び出して、データベースを更新
    user.remember
    # クッキーにユーザIDを登録
    cookies.permanent.encrypted[:user_id] = user.id
    # クッキーにトークンを登録 
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 現在ログイン中のユーザーを返却
  def current_user
    if (user_id = session[:user_id])
      user = User.find_by(id: user_id)
      if user && session[:session_token] == user.session_token
        @current_user = user
      end
    elsif (user_id = cookies.encrypted[:user_id])
      # 永続セッション用クッキーにユーザーIDが保存されている場合
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        # クッキーの remember_token と DB の remember_digest が一致している場合
        # セッションにログイン情報を保存
        log_in user
        @current_user = user
      end
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # 永続的セッションを破棄する
  def forget(user)
    # user.rb の forget メソッドを呼び出して、データベースを更新
    user.forget
    # クッキーのユーザIDを削除
    cookies.delete(:user_id)
    # クッキ−のトークンを削除
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    # 永続的セッションを破棄する
    forget(current_user)
    reset_session
    @current_user = nil
  end
end
