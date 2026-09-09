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
RSpec unit, request, job, security, and browser test suite.

## Features

- Native Rails 8 password authentication with role-based authorization.
- Visitor registration and private self-service user profiles.
- Administrative dashboard with live user and role counters.
- Full administrative user CRUD and one-click role changes.
- Avatar uploads through Active Storage or validated remote URLs.
- Asynchronous CSV/XLSX imports with row-level errors and live progress.
- Responsive, accessible Tailwind UI enhanced with Turbo and Stimulus.

## Technology Stack

- Ruby 4.0.6 and Rails 8.0.5.1
- PostgreSQL 17
- Docker and Docker Compose
- Hotwire (Turbo and Stimulus), Propshaft, and Tailwind CSS
- Solid Queue and Solid Cable (no Redis dependency)
- RSpec Rails, Factory Bot, Capybara, Selenium, and SimpleCov
- RuboCop Rails Omakase and Brakeman
- Thruster, Kamal 2, Ruby ZJIT, and GitHub Actions

## Architecture

The application is a Rails monolith. PostgreSQL stores application data and
the separate Solid Queue and Solid Cable schemas. The `worker` Compose service
processes spreadsheet imports. Import records broadcast progress through
Turbo Streams, while user lifecycle callbacks broadcast updated dashboard
counters. Browser state remains server-driven; Stimulus adds immediate form
validity feedback without duplicating backend rules.

## Project Structure

- `app/` — Rails models, controllers, views, jobs, and mailers.
- `config/` — application, database, routes, and environment configuration.
- `db/` — schema, migrations, and seeds.
- `spec/models` and `spec/services` — unit specs.
- `spec/requests` — HTTP integration specs.
- `spec/jobs` and `spec/system` — background processing and browser specs.
- `spec/factories` and `spec/support` — reusable test data and helpers.

## Requirements

- Docker with Docker Compose

No local Ruby or PostgreSQL installation is required.

## Getting Started

Create the local environment file, build the images, prepare the databases,
and seed development data:

```sh
cp .env.example .env
docker compose build
docker compose run --rm web bin/rails db:prepare db:seed
docker compose up
```

Open <http://localhost:3000>. The default development administrator is
`admin@example.com` with password `ChangeMe123!`. Change both seed variables
and the PostgreSQL password in `.env` before using a shared environment.

The stack starts three services: `web` (Rails/Thruster-compatible app), `worker`
(Solid Queue), and `db` (PostgreSQL). Stop them with `docker compose down`;
append `-v` only when intentionally deleting local database and gem volumes.

## Spreadsheet Imports

Administrators can upload `.csv` or `.xlsx` files from **Imports**. The first
row must contain `full_name` and `email`. Optional columns are `role` (`admin`,
`true`, `yes`, or `1` grants admin) and `avatar_url`. Each imported account gets
a random password and should use the password-reset flow before first login.
Invalid rows are isolated and reported without rolling back valid rows.

## Tests and Quality Checks

Run the complete test suite:

```sh
docker compose run --rm web bundle exec rspec
```

SimpleCov enforces at least 90% line coverage. Open `coverage/index.html` after
a run for the detailed report. To distribute specs between two processes:

```sh
docker compose run --rm web bin/rails parallel:create parallel:prepare
docker compose run --rm web bundle exec parallel_rspec spec -n 2
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
docker compose run --rm web bin/importmap audit
```

The browser suite uses headless Chromium. The UI relies on progressive
enhancement, semantic HTML, standard form controls, and responsive CSS so core
flows remain usable on current Chrome, Firefox, Safari, and Edge releases.

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

## Security and Credentials

Passwords use BCrypt, session IDs are stored in signed, HTTP-only, same-site
cookies, state-changing forms include CSRF tokens, and authorization is
enforced server-side. Email uniqueness is backed by a database index. Uploaded
avatars and spreadsheets enforce type/extension and size limits. SQL injection,
XSS escaping, CSRF configuration, and authorization boundaries have automated
coverage.

Production secrets belong in Rails credentials or deployment environment
variables. Edit encrypted credentials with:

```sh
docker compose run --rm -e EDITOR=vi web bin/rails credentials:edit
```

Never commit `.env`, `config/master.key`, or production credentials.

## Deployment

`config/deploy.yml` provides a Kamal 2 template with separate web and job hosts.
Replace the example hosts, registry, and domain, then provide the listed secret
environment variables before running `bin/kamal deploy`. The production image
runs behind Thruster and enables Ruby 4 ZJIT through `RUBYOPT=--zjit`.
