# DatagenErlport

```
iex(1)> a = :code.priv_dir(:datagen_erlport) |> Path.join("echo.py")
"/home/pikender/elixir/manu/anon-ai/datagen_erlport/_build/dev/lib/datagen_erlport/priv/echo.py"
iex(2)> {:ok, pid} = DatagenErlport.Echo.start_link(a)
{:ok, #PID<0.150.0>}
iex(3)> iex(4)> DatagenErlport.Echo.echo("me-myself\n")
** (CompileError) iex:3: undefined function iex/1
    (stdlib) lists.erl:1354: :lists.mapfoldl/3
iex(3)> DatagenErlport.Echo.echo("me-myself\n")
Eol: "me-myself\n"
Only Eol: "me-myself\n"
[
  ["('Received', 'me-myself\\n')"],
  ["('Current time is', 'Mon Mar 11 21:38:06", " 2019')"]
]
iex(4)> Process.exit(pid, :normal)
true
iex(5)> Process.alive?(pid)
false
```
