defmodule Auth do
  def authenticate(code) do
    password == code && cookie
  end

  def authenticated?(code) do
    cookie == code
  end

  def password do
    Application.get_env :auth, :password
  end

  def cookie do
    Application.get_env :auth, :cookie
  end
end
