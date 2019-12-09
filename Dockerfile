FROM elixir:1.9.4-slim
WORKDIR /app
ADD . .
RUN	mix local.hex --force
RUN	mix local.rebar --force
RUN	mix deps.get
RUN	mix escript.build
CMD ["/app/gver_diff", "2", "gt", "3"]
