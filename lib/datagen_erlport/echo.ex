defmodule DatagenErlport.Echo do
  alias DatagenErlport.Errors.{InvalidStdinNewline}

  use GenServer

  def echo(msg) do
    msg
    |> validate_eol()
    |> IO.inspect(label: "Eol")
    |> validate_only_one_eol(?\n)
    |> IO.inspect(label: "Only Eol")

    GenServer.call(:echo, {:echo, msg})
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

  defp count_chars(str, char) do
    length(for x <- to_charlist(str), x == char, do: x)
  end

  # GenServer

  def start_link(ext_prg) do
    GenServer.start_link(__MODULE__, ext_prg, name: :echo)
  end

  def init(ext_prg) do
    Process.flag(:trap_exit, true)
    port = Port.open({:spawn, ext_prg}, [:binary, :stream, {:line, get_maxline()}])
    {:ok, %{cmd: ext_prg, port: port}}
  end

  def handle_call({:echo, msg}, _from, %{port: port} = state) do
    Port.command(port, msg)
    case collect_resp(port) do
      {:response, resp} ->
        {:reply, resp, state}
      :timeout ->
        {:stop, :port_timeout, state}
    end
  end

  def handle_info({:EXIT, port, reason}, %{port: port} = state) do
    {:stop, {:port_terminated, reason}, state}
  end

  def terminate({:port_terminated, _reason}, %{port: _port} = _state) do
    :ok
  end

  def terminate(_reason, %{port: port} = _state) do
    Port.close(port)
  end

  defp get_maxline() do
    40
  end

  defp collect_resp(port) do
    collect_resp(port, [], [])
  end

  defp collect_resp(port, resp_acc, line_acc) do
    receive do
      {port, {:data, {:eol, "OK"}}} ->
        {:response, Enum.reverse(resp_acc)}
      {port, {:data, {:eol, result}}} ->
        line = Enum.reverse([result | line_acc])
        collect_resp(port, [line | resp_acc], [])
      {port, {:data, {:noeol, result}}} ->
        collect_resp(port, resp_acc, [result | line_acc])
    after
      5000 -> :timeout
    end
  end
end

defmodule DatagenErlport.Errors.InvalidStdinNewline do
  defexception message: "Invalid end of newline"

  def full_message(error) do
    "Invalid Newline Failure :: #{error.message}"
  end
end
