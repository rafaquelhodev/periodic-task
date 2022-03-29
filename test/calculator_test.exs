defmodule RetryTest do
  use ExUnit.Case

  alias Calculator

  test "start periodic stask" do
    {:ok, pid} = Calculator.start_link([])

    Calculator.add_periodic(pid, 2)

    :timer.sleep(2000)

    result = Calculator.see_result(pid)

    assert result > 0
  end
end
