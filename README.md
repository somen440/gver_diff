# GverDiff [![CircleCI](https://circleci.com/gh/somen440/gver_diff.svg?style=shield)](https://circleci.com/gh/somen440/gver_diff) [![Coverage Status](https://coveralls.io/repos/github/somen440/gver_diff/badge.svg)](https://coveralls.io/github/somen440/gver_diff) [![hex.pm version](https://img.shields.io/hexpm/v/gver_diff.svg)](https://hex.pm/packages/gver_diff) [![hex.pm](https://img.shields.io/hexpm/l/gver_diff.svg)](https://github.com/somen440/gver_diff/blob/master/LICENSE)

## LINK

- [Docker Hub gver_diff](https://hub.docker.com/r/mentol310/gver_diff)
- [Hex gver_diff](https://hex.pm/packages/gver_diff)

## Usage

### from Hex

```zsh
$ mix local.hex --force
$ mix local.rebar --force
$ mix escript.install hex gver_diff
$ export PATH=~/.mix/escripts:$PATH
$ gver_diff \
  --type date \
  --regx "dev-(?<version>.*)" \
  dev-20111223 gt dev-20111224
false
```

### from DockerHub

```zsh
$ docker run --rm -it \
    mentol310/gver_diff:0.0.2 \
    /app/gver_diff \
    --type date \
    --regx "dev-(?<version>.*)" \
    dev-20111223 gt dev-20111224
false
```

## Compare Target

specified `type` option

- integer
- string
- float
- date
    - Ymd, Y-m-d
    - 20120506, 2012-05-06
- datetime
    - Y-m-d H:i:s
    - 20120405 12:13:14
- version
    - x.y.z
