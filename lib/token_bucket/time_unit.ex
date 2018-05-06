defmodule TokenBucket.TimeUnit do

  otp_release = :erlang.system_info(:otp_release)

  case :string.to_integer(otp_release) do
    {n, ''} when n == 18 or n == 19 ->
      def ms do
        :milli_seconds
      end

    {n, ''} when n >= 20 ->
      def ms do
        :millisecond
      end

    _ ->
      raise "OTP version #{otp_release} is not supported"
  end

end
