defmodule AWS.S3 do
  @moduledoc """
  """

  def get_object(client, object_name, options \\ []) do
    get_request(client, object_name, options)
  end

  def put_object(client, object_name, input, options \\ []) do
    put_request(client, object_name, input, options)
  end

  defp get_request(client, object_name, options) do
    client = %{client | service: "s3"}
    bucket = options[:bucket]
    host = "s3-#{client.region}.#{client.endpoint}"
    url = "https://#{host}/#{bucket}/#{object_name}"
    input = ""
    payload_sha = AWS.Util.sha256_hexdigest(input)

    headers = %{
      "Host" => host,
    }
    headers = AWS.Request.sign_v4(client, "GET", url, Enum.into(headers, []), input)
    headers = Enum.into(headers, %{})
    headers = Dict.put(headers, "X-Amz-Content-Sha256", payload_sha)
    headers = Enum.into(headers, [])

    case HTTPoison.get(url, headers, []) do
      {:ok, response=%HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body, response}
      {:ok, _response=%HTTPoison.Response{body: body}} ->
        {:error, body}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, %HTTPoison.Error{reason: reason}}
    end
  end

  defp put_request(client, object_name, input, options) do
    client = %{client | service: "s3"}
    bucket = options[:bucket]
    host = "s3-#{client.region}.#{client.endpoint}"
    url = "https://#{host}/#{bucket}/#{object_name}"
    payload_sha = AWS.Util.sha256_hexdigest(input)

    headers = %{
      "Host" => host,
      "Content-Type" => "text/plain",
    }
    headers = AWS.Request.sign_v4(client, "PUT", url, Enum.into(headers, []), input)
    headers = Enum.into(headers, %{})
    headers = Dict.put(headers, "X-Amz-Content-Sha256", payload_sha)
    headers = Enum.into(headers, [])

    case HTTPoison.put(url, input, headers, []) do
      {:ok, response=%HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body, response}
      {:ok, _response=%HTTPoison.Response{body: body}} ->
        {:error, body}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, %HTTPoison.Error{reason: reason}}
    end
  end
end
