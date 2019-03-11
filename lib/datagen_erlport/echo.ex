defmodule DatagenErlport.Echo do
  alias DatagenErlport.Errors.{InvalidStdinNewline}

  def echo(msg) do
    msg
    |> validate_eol()
    |> IO.inspect(label: "Eol")
    |> validate_only_one_eol(?\n)
    |> IO.inspect(label: "Only Eol")
  end

  def validate_eol(msg) do
    case is_newline_terminated(to_charlist(msg)) do
      true -> msg
      false -> raise(InvalidStdinNewline)
    end
  end

  def validate_only_one_eol(msg, char) do
    case count_chars(to_charlist(msg), char) do
      1 -> msg
      _ -> raise(InvalidStdinNewline)
    end
  end

  defp is_newline_terminated([]), do: false
  defp is_newline_terminated('\n'), do: true
  defp is_newline_terminated([_|t]), do: is_newline_terminated(t)

  def count_chars(str, char) do
    length(for x <- to_charlist(str), x == char, do: x)
  end
end

defmodule DatagenErlport.Errors.InvalidStdinNewline do
  defexception message: "Invalid end of newline"

  def full_message(error) do
    "Invalid Newline Failure :: #{error.message}"
  end
end
