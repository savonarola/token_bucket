[![Build Status](https://travis-ci.org/savonarola/token_bucket.svg?branch=master)](https://travis-ci.org/savonarola/token_bucket)
[![Coverage Status](https://coveralls.io/repos/github/savonarola/token_bucket/badge.svg?branch=master)](https://coveralls.io/github/savonarola/token_bucket?branch=master)

<a href="https://funbox.ru">
  <img src="http://funbox.ru/badges/sponsored_by_funbox_compact.svg" alt="Sponsored by FunBox" width=250 />
</a>

# TokenBucket

Rate limiter implementing Token Bucket algorithm https://en.wikipedia.org/wiki/Token_bucket

## Installation

The package can be installed
by adding `token_bucket` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:token_bucket, "~> 0.1.0"}
  ]
end
```

## Usage

```elixir
    # Bucket size 10000, add 1000 tokens to bucket each second.
    # This allows peaks of load in 10000 tokens (requests) in a moment and still keeps average load
    # below 1000 tokens per second.
    {:ok, pid} = TokenBucket.start_link(10_000, 1_000)

    true = TokenBucket.consume(pid, 1)

    # Equivalently
    true = TokenBucket.consume(pid)
```

More precise tuning:

```elixir
    # Bucket size 2, add 1 token to bucket each 100 ms.
    {:ok, pid} = TokenBucket.start_link(2, {1, 100})

    true = TokenBucket.consume(pid)
    true = TokenBucket.consume(pid)
    false = TokenBucket.consume(pid)

    :timer.sleep(120)

    true = TokenBucket.consume(pid)
    false = TokenBucket.consume(pid)
```

Using arbitrary `GenServer` options:

```elixir
    # Register locally as `:my_limiter`.
    {:ok, pid} = TokenBucket.start_link(10_000, 1_000, name: :my_limiter)
```

## LICENSE

This software is licensed under [MIT License](LICENSE).

