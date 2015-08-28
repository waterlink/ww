defmodule Web do
  use Plug.Router

  plug Plug.Logger
  plug AuthPlug
  plug :match
  plug :dispatch

  get "/health" do
    send_resp(conn, 200, "OK")
  end

  get "/" do
    send_file(conn, 200, "priv/signin.html")
  end

  get "/dbg" do
    cookie = fetch_cookies(conn).cookies["auth_cookie"]
    if Auth.authenticated?(cookie) do
      conn |> send_resp(200, "Yay!")
    else
      conn |> send_resp(200, "Nope :(")
    end
  end

  get "/wiki" do
    conn |> render_page("HomePage")
  end

  get "/wiki/:id" do
    conn |> render_page(id)
  end

  get "/wiki/:id/raw" do
    conn |> render_raw_page(id)
  end

  get "/wiki/:id/edit" do
    conn |> send_file(200, "priv/edit.html")
  end

  post "/wiki/update" do
    params = post_params(conn)
    Page.save(params["id"], params["body"])
    id = params["id"]
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, "Done: <a href='/wiki/#{id}'>#{id}</a>")
  end

  post "/authenticate" do
    params = post_params(conn)
    cookie = Auth.authenticate(params["code"])
    if cookie do
      conn
      |> put_resp_content_type("text/html")
      |> put_resp_cookie("auth_cookie", cookie)
      |> send_resp(200, "Success! Go to <a href='/wiki'>HomePage</a>")
    else
      conn |> send_resp(403, "Wrong password.")
    end
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end

  defp render_page(conn, id) do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, page_body(id))
  end

  defp render_raw_page(conn, id) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, page_raw_body(id))
  end

  def page_body(id) do
    Page.find(id).body
  end

  def page_raw_body(id) do
    Page.find(id).raw_body
  end

  def post_params(conn) do
    {:ok, body, _} = read_body(conn)
    Plug.Conn.Query.decode(body)
  end
end
