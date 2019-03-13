# DatagenErlport

```
iex(1)> a = :code.priv_dir(:datagen_erlport) |> Path.join("echo.py")
"/home/pikender/elixir/manu/anon-ai/datagen_erlport/_build/dev/lib/datagen_erlport/priv/echo.py"
iex(2)> {:ok, pid} = DatagenErlport.Echo.start_link(a)
{:ok, #PID<0.150.0>}
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

```
iex(24)> DatagenErlport.OneOff2.echo(a)
Line: ["('Received', 'First line')"]
Unfinished line: "('Current time is', 'Wed Mar 13 17:47:46"
Line: ["('Current time is', 'Wed Mar 13 17:47:46", " 2019')"]
End: "OK"
End of File: [
  ["('Received', 'First line')"],
  ["('Current time is', 'Wed Mar 13 17:47:46", " 2019')"]
]
"Port Closed"
Set Exit status: 0
{:ok, #PID<0.194.0>}
EXIT called: :normal
```
