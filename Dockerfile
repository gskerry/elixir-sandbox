FROM elixir

WORKDIR /home/myapp

RUN mix local.hex --force
RUN mix local.rebar --force

EXPOSE 4000

CMD [ "echo", "Welcome to Elixir." ]
