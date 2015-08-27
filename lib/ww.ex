defmodule WW do
  def start(_type, _args) do
    result = Plug.Adapters.Cowboy.http Web, []
    IO.puts "Listening on http://localhost:4000"
    result
  end
end
