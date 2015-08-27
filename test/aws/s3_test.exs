defmodule AWS.S3Test do
  use ExUnit.Case

  test "it works" do
    :random.seed(:os.timestamp)
    text = "hello world #{:random.uniform}"

    aws_key = System.get_env("AWS_ACCESS_KEY_ID")
    aws_secret = System.get_env("AWS_SECRET_ACCESS_KEY")
    client = %AWS.Client{
      access_key_id: aws_key,
      secret_access_key: aws_secret,
      region: "eu-west-1",
      endpoint: "amazonaws.com",
    }
    AWS.S3.put_object(client, "greeting.txt", text, bucket: "wikiwords-test")

    {:ok, actual, _} = AWS.S3.get_object(client, "greeting.txt", bucket: "wikiwords-test")
    assert actual == text
  end
end
