# Periodic-task

This is a simple example where a periodic task is created with the aid of Elixir OTP.

## Usage

```sh
iex -S mix
```

```elixir
import Calculator

{:ok, pid} = Calculator.start_link([])

Calculator.add_periodic(pid, 2)
```

And voila, we'll see something like this:
```sh
2
4
6
8
...
```
