defmodule DatagenErlport.Echo do
  alias DatagenErlport.Errors.{InvalidStdinNewline}

  def echo(msg) do
    case is_newline_terminated(to_charlist(msg)) do
      true -> msg
      false -> raise(InvalidStdinNewline)
    end
  end

  defp is_newline_terminated([]), do: false
  defp is_newline_terminated('\n'), do: true
  defp is_newline_terminated([_|t]), do: is_newline_terminated(t)
end

defmodule DatagenErlport.Errors.InvalidStdinNewline do
  defexception message: "Invalid end of newline"

  def full_message(error) do
    "Invalid Newline Failure :: #{error.message}"
  end
end
