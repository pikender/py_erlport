defmodule DatagenErlportTest do
  use ExUnit.Case

  alias DatagenErlport.{Echo, Errors}

  @invalid_message_bw "m\ne"
  @invalid_message "me"
  @invalid_message_m "me \n\n"
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

    test "not terminated by newline but having in b/w raises exception" do
      assert_raise Errors.InvalidStdinNewline, fn ->
        Echo.echo(@invalid_message_bw)
      end
    end

    test "only one newline in message" do
      assert @valid_message == Echo.echo(@valid_message)
    end

    test "more than one newline in message" do
      assert_raise Errors.InvalidStdinNewline, fn ->
        Echo.echo(@invalid_message_m)
      end
    end
  end
end
