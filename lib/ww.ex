defmodule WW do
  def start(_type, _args) do
    {port, _} = Integer.parse(System.get_env("PORT") || "4000")
    result = Plug.Adapters.Cowboy.http Web, [], port: port
    IO.puts "Listening on http://localhost:#{port}"
    result
  end
end
