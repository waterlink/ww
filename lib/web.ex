defmodule Web do
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug :dispatch

  get "/health" do
    send_resp(conn, 200, "OK")
  end

  get "/wiki" do
    conn |> render_page("HomePage")
  end

  get "/wiki/:id" do
    conn |> render_page(id)
  end

  get "/wiki/:id/edit" do
    conn |> send_file(200, "priv/edit.html")
  end

  post "/wiki/update" do
    {:ok, body, _} = read_body(conn)
    params = Plug.Conn.Query.decode(body)
    Page.save(params["id"], params["body"])
    conn |> send_resp(200, "Done")
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end

  defp render_page(conn, id) do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, page_body(id))
  end

  def page_body(id) do
    Page.find(id).body
  end
end
