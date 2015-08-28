defmodule Page do
  defstruct id: "HomePage", body: "", raw_body: ""

  def find(id) do
    body = fetch_body(id)
    %Page{
      id: id,
      raw_body: body,
      body: generate_html(body),
    }
  end

  def save(id, body) do
    {:ok, _, _} = AWS.S3.put_object(aws_client, id, body, bucket: aws_bucket)
  end

  defp fetch_body(id) do
    case AWS.S3.get_object(aws_client, id, bucket: aws_bucket) do
      {:ok, body, _} -> body
      _ -> stub(id)
    end
  end

  defp generate_html(body) do
    Earmark.to_html(body)
  end

  defp aws_client do
    %AWS.Client{
      access_key_id: Application.get_env(:aws, :key),
      secret_access_key: Application.get_env(:aws, :secret),
      region: Application.get_env(:aws, :region),
      endpoint: "amazonaws.com",
    }
  end

  defp aws_bucket do
    Application.get_env(:aws, :bucket)
  end

  defp stub(id) do
    "This page is a stub. You can edit this page [here](/wiki/#{id}/edit)"
  end
end
