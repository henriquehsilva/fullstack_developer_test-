# Fullstack Developer Test

Rails 8.0 application running on Ruby 4.0 with PostgreSQL.

## Requirements

- Docker with Docker Compose

## Development

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
