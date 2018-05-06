defmodule TokenBucket do
  @moduledoc """
  Rate limiter implementing Token Bucket algorithm https://en.wikipedia.org/wiki/Token_bucket
  """

  use GenServer

  defmodule St do
    defstruct bucket_size: 0,
              tokens: 0,
              fill_count: 0,
              fill_interval: 0,
              time: 0
  end

  # ms
  @default_timeout 5_000

  # ms
  @default_fill_interval 1_000

  def start_link(bucket_size, fill_rate, options \\ [])

  def start_link(bucket_size, fill_count, options) when is_number(fill_count) do
    start_link(bucket_size, {fill_count, @default_fill_interval}, options)
  end

  def start_link(bucket_size, {fill_count, fill_interval}, options)
      when is_number(bucket_size) and is_number(fill_count) and is_number(fill_interval) and
             bucket_size > 0 and fill_count > 0 and fill_interval > 0 do
    GenServer.start_link(__MODULE__, [bucket_size, fill_count, fill_interval], options)
  end

  def consume(srv, size \\ 1, timeout \\ @default_timeout) do
    GenServer.call(srv, {:consume, size}, timeout)
  end

  @impl true
  def init([bucket_size, fill_count, fill_interval]) do
    st = %St{
      bucket_size: float(bucket_size),
      tokens: float(bucket_size),
      fill_count: float(fill_count),
      fill_interval: float(fill_interval),
      time: time()
    }

    {:ok, st}
  end

  @impl true
  def handle_call({:consume, size}, _from, st) do
    new_st = update_bucket(st, time())

    {new_tokens, reply} =
      if new_st.tokens >= size do
        {new_st.tokens - size, true}
      else
        {new_st.tokens, false}
      end

    {:reply, reply, %St{new_st | tokens: new_tokens}}
  end

  defp update_bucket(st, now) do
    if time_to_fill?(st, now) do
      intervals_passed = fill_intervals_passed(st, now)
      new_time = st.time + st.fill_interval * intervals_passed * 1_000_000
      tokens_to_add = st.fill_count * intervals_passed
      new_tokens = min(st.bucket_size, st.tokens + tokens_to_add)
      %St{st | time: new_time, tokens: new_tokens}
    else
      st
    end
  end

  defp float(n) do
    1.0 * n
  end

  defp time do
    :erlang.monotonic_time(:nanosecond)
  end

  defp time_to_fill?(st, now_time) do
    st.fill_interval * 1_000_000 <= now_time - st.time
  end

  defp fill_intervals_passed(st, now) do
    Float.floor((now - st.time) / (st.fill_interval * 1_000_000))
  end
end
