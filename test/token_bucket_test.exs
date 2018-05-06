defmodule TokenBucketTest do
  use ExUnit.Case

  test "rate limiting" do
    {:ok, pid} = TokenBucket.start_link(2, {1, 100})

    assert true == TokenBucket.consume(pid, 1)
    assert true == TokenBucket.consume(pid, 1)
    assert false == TokenBucket.consume(pid, 1)

    :timer.sleep(120)

    assert true == TokenBucket.consume(pid, 1)
    assert false == TokenBucket.consume(pid, 1)

    :timer.sleep(90)

    assert true == TokenBucket.consume(pid, 1)
    assert false == TokenBucket.consume(pid, 1)
  end

  test "rate limiting: stats" do
    # 10 tokens each 10 ms
    {:ok, tb} = TokenBucket.start_link(10, {10, 10})
    {:ok, a} = Agent.start(fn -> 0 end)

    loop = fn next_loop ->
      if TokenBucket.consume(tb) do
        Agent.update(a, &(&1 + 1))
      end

      next_loop.(next_loop)
    end

    spawn_link(fn ->
      loop.(loop)
    end)

    :timer.sleep(1_000)

    consumed = Agent.get(a, & &1)
    expected_consumed = 1010

    assert abs((expected_consumed - consumed) / expected_consumed) < 0.01
  end
end
