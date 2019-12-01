build:
	mix local.hex --force
	mix local.rebar --force
	mix deps.get
	mix escript.build

test:
	mix test

cover:
	MIX_ENV=test mix coveralls.circle

cover_local:
	MIX_ENV=test mix coveralls.html

.PHONY: test, cover
