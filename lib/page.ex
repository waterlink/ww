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
    {:ok, _, _} = AWS.S3.put_object(aws_client, id, body, bucket: "wikiwords-test")
  end

  defp fetch_body(id) do
    case AWS.S3.get_object(aws_client, id, bucket: "wikiwords-test") do
      {:ok, body, _} -> body
      _ -> stub(id)
    end
  end

  defp generate_html(body) do
    Earmark.to_html(body)
  end

  defp aws_client do
    aws_key = System.get_env("AWS_ACCESS_KEY_ID")
    aws_secret = System.get_env("AWS_SECRET_ACCESS_KEY")
    %AWS.Client{
      access_key_id: aws_key,
      secret_access_key: aws_secret,
      region: "eu-west-1",
      endpoint: "amazonaws.com",
    }
  end

  defp stub(id) do
    "This page is a stub. You can edit this page [here](/wiki/#{id}/edit)"
  end
end
