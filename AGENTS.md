# Repository Guidelines

## Project Structure & Module Organization

This is a Rails 8 application. Keep domain code in `app/models`, request handling in `app/controllers`, views in `app/views`, and reusable services in `app/services`. Database migrations and seeds belong in `db/`; configuration lives in `config/`; Minitest tests mirror application code under `test/`. Docker development files are at the repository root.

## Build, Test, and Development Commands

Use Docker Compose so development matches the documented Ruby and PostgreSQL versions:

- `docker compose up --build` — build and start Rails and PostgreSQL.
- `docker compose run --rm web bundle exec rspec` — run all unit and integration specs.
- `docker compose run --rm web bin/rubocop` — check Ruby style.
- `docker compose run --rm web bin/brakeman --no-pager` — scan for Rails security issues.

Document any required services, environment variables, or setup steps in `README.md`, and keep these commands working in CI.

## Coding Style & Naming Conventions

Follow `rubocop-rails-omakase` through `bin/rubocop`. Use two-space indentation. Name Ruby classes and modules in `PascalCase`, methods and variables in `snake_case`, and constants in `UPPER_SNAKE_CASE`. Follow Rails naming conventions: singular model names (`User`) and plural controller names (`UsersController`).

## Testing Guidelines

Add RSpec coverage with every behavior change and bug fix. Put unit specs under `spec/models` or `spec/services`, request-level integration specs under `spec/requests`, factories under `spec/factories`, and shared helpers under `spec/support`. Name files `*_spec.rb`, such as `spec/models/user_spec.rb`. Cover successful flows, validation failures, and boundary cases; avoid tests that depend on execution order or external state.

## Commit & Pull Request Guidelines

Use Git Flow branches (`feature/*`, `release/*`, and `hotfix/*`) and short English Conventional Commit subjects, for example `feat: add user registration`. Pull requests should target `develop`, explain the motivation and approach, list verification commands, link related issues, and include screenshots for visible UI changes. Keep each pull request focused and call out migrations or configuration changes explicitly.

## Security & Configuration

Never commit credentials or populated environment files. Provide safe placeholders in `.env.example`, validate configuration at startup, and review new dependencies before adoption.
