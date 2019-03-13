defmodule DatagenErlport.OneOff2 do
  # https://stackoverflow.com/questions/27028486/how-to-execute-system-command-in-erlang-and-get-results-unreliable-oscmd-1

  use GenServer

  def echo(cmd) do
    with {:ok, pid} <- start(cmd),
         :ok <- GenServer.call(pid, :start) do
      {:ok, pid}
    end
  end

  # GenServer

  def start(ext_prg) do
    GenServer.start(__MODULE__, ext_prg, name: :one_off)
  end

  def start_link(ext_prg) do
    GenServer.start_link(__MODULE__, ext_prg, name: :one_off)
  end

  def init(ext_prg) do
    Process.flag(:trap_exit, true)
    {:ok, %{cmd: ext_prg}}
  end

  def handle_call(:start, _from, %{cmd: ext_prg} = state) do
    port =
      Port.open(
        {:spawn, ext_prg},
        [
          :binary, :stream, :in, :eof, :exit_status,
          {:line, get_maxline()}
        ]
      )
    new_state = Map.put(state, :port, port)
    collect_resp(port)
    {:reply, :ok, new_state}
  end

  def handle_info({:EXIT, port, reason}, %{port: port} = state) do
    IO.inspect reason, label: "EXIT called"
    {:noreply, state}
    #{:stop, {:port_terminated, reason}, state}
  end

  def handle_info({port, {:exit_status, exit_status}}, %{port: port} = state) do
    IO.inspect exit_status, label: "Set Exit status"
    new_state = Map.put(state, :exit_status, exit_status)
    {:noreply, new_state}
  end

  def terminate({:port_terminated, _reason}, _state) do
    :ok
  end

  def terminate(_reason, %{port: port} = _state) do
    Port.close(port)
    :ok
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
        IO.inspect "OK", label: "End"
        collect_resp(port, resp_acc, line_acc)
      {port, {:data, {:eol, result}}} ->
        line = Enum.reverse([result | line_acc])
        IO.inspect line, label: "Line"
        collect_resp(port, [line | resp_acc], [])
      {port, {:data, {:noeol, result}}} ->
        IO.inspect result, label: "Unfinished line"
        collect_resp(port, resp_acc, [result | line_acc])
      {port, {:data, anything}} ->
        IO.inspect anything, label: "Anything"
        collect_resp(port, resp_acc, line_acc)
      {port, :eof} ->
        IO.inspect Enum.reverse(resp_acc), label: "End of File"
        send(port, {self(), :close})
        receive do
          {port, :closed} ->
            IO.inspect "Port Closed"
            true
        end
    after
      10_000 -> :timeout
    end
  end
end
