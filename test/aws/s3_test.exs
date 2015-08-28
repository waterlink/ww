defmodule AWS.S3Test do
  use ExUnit.Case

  test "it works" do
    :random.seed(:os.timestamp)
    text = "hello world #{:random.uniform}"

    bucket = Application.get_env(:aws, :bucket)
    client = %AWS.Client{
      access_key_id: Application.get_env(:aws, :key),
      secret_access_key: Application.get_env(:aws, :secret),
      region: Application.get_env(:aws, :region),
      endpoint: "amazonaws.com",
    }
    AWS.S3.put_object(client, "greeting.txt", text, bucket: bucket)

    {:ok, actual, _} = AWS.S3.get_object(client, "greeting.txt", bucket: bucket)
    assert actual == text
  end
end
