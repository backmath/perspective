defmodule Web.Controller do
  use Phoenix.Controller, namespace: Web

  def index(conn, _params) do
    data = %{
      ok: :josé,
      wee: :woo,
      git_hash: System.get_env("PERSPECTIVE_RELEASE")
    }

    json(conn, data)
  end

  def inc(conn, _params) do
    count =
      conn
      |> Plug.Conn.fetch_query_params()
      |> Map.get(:params)
      |> IO.inspect()
      |> Map.get("count", "0")
      |> Integer.parse()
      |> elem(0)

    data = %{
      important_things_completed: count
    }

    Web.Endpoint.broadcast!("home:important_things", "update", data)

    json(conn, data)
  end
end
