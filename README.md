# Fullstack Developer Test

## AI Usage Disclosure

This submission was generated, structured, and refined with **OpenAI Codex
(GPT-5)**. The assistant was used to scaffold the Rails application, configure
Docker and PostgreSQL, establish the RSpec test structure, write documentation,
and support Git Flow operations. All generated changes were reviewed and
validated during development.

![Ruby](https://img.shields.io/badge/Ruby-4.0.6-CC342D?logo=ruby&logoColor=white)
![Rails](https://img.shields.io/badge/Rails-8.0.5.1-D30001?logo=rubyonrails&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-17-4169E1?logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)
![RSpec](https://img.shields.io/badge/RSpec-8.0-CC0000?logo=ruby&logoColor=white)

Rails 8 application running on Ruby 4, PostgreSQL, and Docker Compose, with an
RSpec unit and integration test foundation.

## Technology Stack

- Ruby 4.0.6 and Rails 8.0.5.1
- PostgreSQL 17
- Docker and Docker Compose
- RSpec Rails and Factory Bot
- RuboCop Rails Omakase and Brakeman
- GitHub Actions

## Project Structure

- `app/` — Rails models, controllers, views, jobs, and mailers.
- `config/` — application, database, routes, and environment configuration.
- `db/` — schema, migrations, and seeds.
- `spec/models` and `spec/services` — unit specs.
- `spec/requests` — HTTP integration specs.
- `spec/factories` and `spec/support` — reusable test data and helpers.

## Requirements

- Docker with Docker Compose

No local Ruby or PostgreSQL installation is required.

## Getting Started

Create the local environment file and start the stack:

```sh
cp .env.example .env
docker compose up --build
```

Open <http://localhost:3000>. Rails waits for PostgreSQL and prepares the
database during startup. Change the sample database password before using the
stack in a shared or externally accessible environment.

## Tests and Quality Checks

Run the complete test suite:

```sh
docker compose run --rm web bundle exec rspec
```

Run a specific unit or integration spec:

```sh
docker compose run --rm web bundle exec rspec spec/models/application_record_spec.rb
docker compose run --rm web bundle exec rspec spec/requests/health_check_spec.rb
```

Run style and security checks:

```sh
docker compose run --rm web bin/rubocop
docker compose run --rm web bin/brakeman --no-pager
```

## Database Commands

Prepare or migrate the database:

```sh
docker compose run --rm web bin/rails db:prepare
```

Open a PostgreSQL console:

```sh
docker compose exec db psql -U postgres -d fullstack_developer_test_development
```

Database settings are defined in `.env`; use `.env.example` as the safe
template and never commit real credentials.
