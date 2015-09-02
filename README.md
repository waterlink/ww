# WW - WikiWords

Personal WikiWords web application in Elixir

## Development

`mix deps.get` - to fetch all dependencies
`mix test` - to run tests
`iex -S mix` - to run interactive elixir and start server (CTRL+C twice to exit it)

NOTE: to run tests and run development server, you would need to set your AWS
credentials as environment variables:

```bash
export AWS_ACCESS_KEY_ID="your development AWS access key id with r/w access to S3"
export AWS_SECRET_ACCESS_KEY="your development AWS secret access key with r/w access to S3"
```

## Deploy to Heroku

To deploy to heroku, you need to provide such environment variables with
`heroku config:set`:

```
BUILDPACK_URL:         https://github.com/HashNuke/heroku-buildpack-elixir.git

AWS_ACCESS_KEY_ID:     your deployment AWS access key id with r/w access to S3
AWS_SECRET_ACCESS_KEY: your deployment AWS secret access key with r/w access to S3

AUTH_COOKIE:           your unique random long authentication cookie here
AUTH_PASSWORD:         your preferred password to get an auth cookie set
```

## Contributors

- [waterlink](https://github.com/waterlink) - Oleksii Fedorov, creator, maintainer
