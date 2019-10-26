FROM elixir:latest

WORKDIR /app

ENV MIX_ENV prod

RUN mix local.hex --force

RUN mix local.rebar --force

COPY mix.* ./

RUN mix deps.get --only prod

RUN mix deps.compile

COPY . .

RUN mix compile

CMD ["mix", "run", "--no-halt"]
