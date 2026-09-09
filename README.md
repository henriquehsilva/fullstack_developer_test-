# Fullstack Developer Test

Rails 8.0 application running on Ruby 4.0 with PostgreSQL.

## Requirements

- Docker with Docker Compose

## Development

Copy the environment template before starting the services:

```sh
cp .env.example .env
```

Change the sample PostgreSQL password when the environment is shared or
accessible outside your machine. Local defaults allow the stack to start even
when `.env` is absent.

Build the images and start the application:

```sh
docker compose up --build
```

The application is available at <http://localhost:3000>. The web container
waits for PostgreSQL and prepares the database on startup.

Run tests and quality checks in disposable containers:

```sh
docker compose run --rm web bin/rails test
docker compose run --rm web bin/rubocop
docker compose run --rm web bin/brakeman --no-pager
```

Create or migrate the database manually with:

```sh
docker compose run --rm web bin/rails db:prepare
```

Open a PostgreSQL console with:

```sh
docker compose exec db psql -U postgres -d fullstack_developer_test_development
```
