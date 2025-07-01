class ApplicationController < ActionController::Base
  # どのコントローラーからでもログイン関連のメソッドを呼び出せるようにする
  include SessionsHelper
end
