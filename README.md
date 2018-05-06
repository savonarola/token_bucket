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
    # This allows peaks of load in 10000 tokens (requests) in a moment stil keeping average load
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

## LICENSE

This software is licensed under [MIT License](LICENSE).
