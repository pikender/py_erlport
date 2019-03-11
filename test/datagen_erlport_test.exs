defmodule DatagenErlportTest do
  use ExUnit.Case

  alias DatagenErlport.{Echo, Errors}

  @invalid_message "me"

  test "message to python stdin is terminated by a newline" do
    assert_raise Errors.InvalidStdinNewline, fn ->
      Echo.echo(@invalid_message)
    end
  end
end
