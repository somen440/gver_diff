build:
	mix local.hex --force
	mix local.rebar --force
	mix deps.get
	mix escript.build

test:
	mix test --color --trace
.PHONY: test

cs:
	mix format --check-formatted
.PHONY: cs

format:
	mix format
.PHOYNY: format

cover:
	MIX_ENV=test mix coveralls.circle
.PHONY: cover

cover_local:
	MIX_ENV=test mix coveralls.html

dialyzer:
	MIX_ENV=test mix dialyzer --plt
	MIX_ENV=test mix dialyzer
.PHONY: dialyzer

hook:
	cp scripts/hooks/pre-push .git/hooks/pre-push
.PHONY: hook
