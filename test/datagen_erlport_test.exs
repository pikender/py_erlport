defmodule DatagenErlportTest do
  use ExUnit.Case

  alias DatagenErlport.{Echo, Errors}

  @invalid_message "me"
  @valid_message "me \n"

  describe "message to python stdin" do
    test "terminated by newline goes to next step" do
      assert @valid_message == Echo.echo(@valid_message)
    end

    test "not terminated by newline raises exception" do
      assert_raise Errors.InvalidStdinNewline, fn ->
        Echo.echo(@invalid_message)
      end
    end
  end
end
