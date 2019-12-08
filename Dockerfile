FROM elixir:1.9.4
WORKDIR /app
ADD . .
RUN make build
CMD ["/app/gver_diff", "2", "gt", "3"]
