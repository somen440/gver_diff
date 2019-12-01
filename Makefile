build:
	mix local.hex --force
	mix local.rebar --force
	mix deps.get
	mix escript.build

test:
	mix test
.PHONY: test

cs:
	mix format --check-formatted
.PHONY: cs

cover:
	MIX_ENV=test mix coveralls.circle
.PHONY: cover

cover_local:
	MIX_ENV=test mix coveralls.html
