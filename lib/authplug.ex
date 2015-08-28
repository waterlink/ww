defmodule AuthPlug do
  import Plug.Conn

  @behaviour Plug

  def init(opts), do: opts

  def call(conn, otps) do
    case conn.path_info do
      ["wiki"|_] -> verify_auth_cookie(conn)
      _ -> conn
    end
  end

  defp verify_auth_cookie(conn) do
    conn = fetch_cookies(conn)
    cookie = conn.cookies["auth_cookie"]
    if Auth.authenticated?(cookie) do
      conn
    else
      conn
      |> send_resp(403, "Forbidden :(")
      |> halt
    end
  end
end
