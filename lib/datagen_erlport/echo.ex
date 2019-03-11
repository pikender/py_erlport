defmodule DatagenErlport.Echo do
  alias DatagenErlport.Errors.{InvalidStdinNewline}

  def echo(_msg) do
    raise InvalidStdinNewline
  end
end

defmodule DatagenErlport.Errors.InvalidStdinNewline do
  defexception message: "Invalid end of newline"

  def full_message(error) do
    "Invalid Newline Failure :: #{error.message}"
  end
end
