FROM elixir:1.8.1-alpine

ARG MIX_ENV=test

WORKDIR /opt/app

# This step installs all the build tools we'll need
RUN apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache \
    git \
    build-base && \
  mix local.rebar --force && \
  mix local.hex --force

# This copies our app source code into the build container
COPY mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

COPY . .
RUN mix compile
